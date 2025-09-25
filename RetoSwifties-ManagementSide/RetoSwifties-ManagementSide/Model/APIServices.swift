//
//  APIServices.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation
import Combine

enum API {
    static let baseURL = URL(string: "https://swifties.tc2007b.tec.mx:10206")!
}

// MARK: - Endpoints
private enum Endpoint {
    case empleadosDisponibles(query: String?)
    case ventanillasEstado
    case ventanillaAsignar(idVentanilla: Int, idEmpleado: Int)
    case ventanillaLiberar(idVentanilla: Int)

    var request: URLRequest {
        switch self {
        case .empleadosDisponibles(let q):
            var comps = URLComponents(
                url: API.baseURL.appendingPathComponent("/empleados/disponibles"),
                resolvingAgainstBaseURL: false
            )!
            if let q, !q.isEmpty { comps.queryItems = [URLQueryItem(name: "q", value: q)] }
            var r = URLRequest(url: comps.url!)
            r.httpMethod = "GET"
            r.addValue("application/json", forHTTPHeaderField: "Accept")
            return r

        case .ventanillasEstado:
            var r = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/estado"))
            r.httpMethod = "GET"
            r.addValue("application/json", forHTTPHeaderField: "Accept")
            return r

        case .ventanillaAsignar(let idV, let idE):
            var r = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/asignar"))
            r.httpMethod = "POST"
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
            r.addValue("application/json", forHTTPHeaderField: "Accept")
            r.httpBody = try? JSONEncoder().encode(AsignarPayload(idVentanilla: idV, idEmpleado: idE))
            return r

        case .ventanillaLiberar(let idV):
            var r = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/liberar"))
            r.httpMethod = "POST"
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
            r.addValue("application/json", forHTTPHeaderField: "Accept")
            r.httpBody = try? JSONEncoder().encode(LiberarPayload(idVentanilla: idV))
            return r
        }
    }
}

// MARK: - DTOs
private struct APIEmpleado: Codable {
    let idEmpleado: Int
    let nombre: String
}

private struct APIVentanillaEstado: Codable {
    let idVentanilla: Int
    let nombreVentanilla: String?
    let idAsignacion: Int?
    let idEmpleado: Int?
    let nombreEmpleado: String?
}

private struct AsignarPayload: Codable { let idVentanilla: Int; let idEmpleado: Int }
private struct LiberarPayload: Codable { let idVentanilla: Int }

struct APIMessageOK: Codable {
    let ok: Bool?
    let idAsignacion: Int?
    let liberadas: Int?
}

// MARK: - Event Bus
enum AppEvent {
    case ventanillaAsignada(idVentanilla: Int, idEmpleado: Int)
    case ventanillaLiberada(idVentanilla: Int)
}

final class AppEvents {
    static let shared = AppEvents()
    private init() {}
    let publisher = PassthroughSubject<AppEvent, Never>()
    func post(_ e: AppEvent) { DispatchQueue.main.async { [publisher] in publisher.send(e) } }
}

// MARK: - APIService
final class APIService {
    static let shared = APIService()
    private let session: URLSession

    private init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 15
        cfg.timeoutIntervalForResource = 30
        session = URLSession(configuration: cfg)
    }

    private func check(_ resp: URLResponse, _ data: Data) throws {
        if let http = resp as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw URLError(.badServerResponse, userInfo: [
                "status": http.statusCode,
                "body": String(data: data, encoding: .utf8) ?? ""
            ])
        }
    }

    // MARK: - Core GET/POST
    private func get<T: Decodable>(_ ep: Endpoint) async throws -> T {
        let req = ep.request
        let (data, resp) = try await session.data(for: req)
        try check(resp, data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func post<T: Decodable>(_ ep: Endpoint) async throws -> T {
        let req = ep.request
        let (data, resp) = try await session.data(for: req)
        try check(resp, data)
        return try JSONDecoder().decode(T.self, from: data)
    }

    // MARK: - Public API
    func empleadosDisponibles(query: String? = nil) async throws -> [Empleado] {
        let raw: [APIEmpleado] = try await get(.empleadosDisponibles(query: query))
        return raw.map { Empleado(id: $0.idEmpleado, nombre: $0.nombre, disponible: true) }
    }

    func ventanillasEstado() async throws -> [Ventanilla] {
        let raw: [APIVentanillaEstado] = try await get(.ventanillasEstado)
        return raw.map {
            Ventanilla(id: $0.idVentanilla,
                       nombreEmpleado: $0.nombreEmpleado,
                       ocupada: ($0.idEmpleado != nil))
        }
    }

    @discardableResult
    func asignar(idVentanilla: Int, idEmpleado: Int) async throws -> APIMessageOK {
        let r: APIMessageOK = try await post(.ventanillaAsignar(idVentanilla: idVentanilla, idEmpleado: idEmpleado))
        AppEvents.shared.post(.ventanillaAsignada(idVentanilla: idVentanilla, idEmpleado: idEmpleado))
        return r
    }

    @discardableResult
    func liberar(idVentanilla: Int) async throws -> APIMessageOK {
        let r: APIMessageOK = try await post(.ventanillaLiberar(idVentanilla: idVentanilla))
        AppEvents.shared.post(.ventanillaLiberada(idVentanilla: idVentanilla))
        return r
    }
}

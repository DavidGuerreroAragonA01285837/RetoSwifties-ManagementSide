//
//  APIServices.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation
import Combine

// MARK: - Config
enum API {
    // ⚠️ AJUSTA a tu host/puerto reales
    static let baseURL = URL(string: "https://swifties.tc2007b.tec.mx:10206")!

    /// Activa logs verbosos para POST/GET (útil para depurar “no modifica”)
    static var enableNetworkLogging: Bool = true
}

// MARK: - Endpoints
enum Endpoint {
    case empleadosDisponibles(query: String?)
    case ventanillasEstado
    case ventanillaAsignar(idVentanilla: Int, idEmpleado: Int)
    case ventanillaLiberar(idVentanilla: Int)

    var urlRequest: URLRequest {
        switch self {
        case .empleadosDisponibles(let q):
            var comps = URLComponents(url: API.baseURL.appendingPathComponent("/empleados/disponibles"),
                                      resolvingAgainstBaseURL: false)!
            if let q, !q.isEmpty { comps.queryItems = [URLQueryItem(name: "q", value: q)] }
            var req = URLRequest(url: comps.url!)
            req.httpMethod = "GET"
            return req

        case .ventanillasEstado:
            var req = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/estado"))
            req.httpMethod = "GET"
            return req

        case .ventanillaAsignar(let idV, let idE):
            var req = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/asignar"))
            req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = AsignarPayload(idVentanilla: idV, idEmpleado: idE)
            req.httpBody = try? JSONEncoder().encode(body)
            return req

        case .ventanillaLiberar(let idV):
            var req = URLRequest(url: API.baseURL.appendingPathComponent("/ventanillas/liberar"))
            req.httpMethod = "POST"
            req.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let body = LiberarPayload(idVentanilla: idV)
            req.httpBody = try? JSONEncoder().encode(body)
            return req
        }
    }
}

// MARK: - DTOs (API)
struct APIEmpleado: Codable {
    let idEmpleado: Int
    let nombre: String
}

struct APIVentanillaEstado: Codable {
    let idVentanilla: Int
    let nombreVentanilla: String?
    let idAsignacion: Int?
    let idEmpleado: Int?
    let nombreEmpleado: String?
}

struct AsignarPayload: Codable { let idVentanilla: Int; let idEmpleado: Int }
struct LiberarPayload:  Codable { let idVentanilla: Int }

struct APIMessageOK: Codable {
    let ok: Bool?
    let idAsignacion: Int?
    let liberadas: Int?
}

// MARK: - Servicio + EventBus interno
final class APIService {
    static let shared = APIService()
    private let session: URLSession

    // Bus de eventos para que otras capas se enteren sin tocar Views
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

    private init() {
        let cfg = URLSessionConfiguration.default
        cfg.timeoutIntervalForRequest = 15
        cfg.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: cfg)
    }

    // MARK: - Utilería de logging
    private func log(_ title: String, _ text: String) {
        guard API.enableNetworkLogging else { return }
        print("🔎[\(title)] \(text)")
    }
    private func dumpJSON(_ data: Data) -> String {
        guard let obj = try? JSONSerialization.jsonObject(with: data),
              let pretty = try? JSONSerialization.data(withJSONObject: obj, options: .prettyPrinted),
              let s = String(data: pretty, encoding: .utf8) else {
            return String(data: data, encoding: .utf8) ?? "<binario>"
        }
        return s
    }

    // GET genérico
    private func get<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var req = endpoint.urlRequest
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        log("GET", "\(req.httpMethod ?? "") \(req.url?.absoluteString ?? "")")
        let (data, resp) = try await session.data(for: req)
        try APIService.throwIfBad(resp, data)
        log("GET RESP", dumpJSON(data))
        return try JSONDecoder().decode(T.self, from: data)
    }

    // POST genérico
    private func post<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        var req = endpoint.urlRequest
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        if let body = req.httpBody { log("POST BODY", String(data: body, encoding: .utf8) ?? "<binario>") }
        log("POST", "\(req.httpMethod ?? "") \(req.url?.absoluteString ?? "")")
        let (data, resp) = try await session.data(for: req)
        try APIService.throwIfBad(resp, data)
        log("POST RESP", dumpJSON(data))
        return try JSONDecoder().decode(T.self, from: data)
    }

    private static func throwIfBad(_ resp: URLResponse, _ data: Data) throws {
        guard let http = resp as? HTTPURLResponse else { return }
        if !(200..<300).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "<sin cuerpo>"
            throw URLError(.badServerResponse, userInfo: ["status": http.statusCode, "body": body])
        }
    }

    // MARK: - Métodos concretos (tu API)
    func empleadosDisponibles(query: String? = nil) async throws -> [APIEmpleado] {
        try await get(.empleadosDisponibles(query: query))
    }

    func ventanillasEstado() async throws -> [APIVentanillaEstado] {
        try await get(.ventanillasEstado)
    }

    /// Hace el POST y además trae el estado para verificar
    func asignar(idVentanilla: Int, idEmpleado: Int) async throws -> (APIMessageOK, [APIVentanillaEstado]) {
        let r: APIMessageOK = try await post(.ventanillaAsignar(idVentanilla: idVentanilla, idEmpleado: idEmpleado))
        APIService.AppEvents.shared.post(.ventanillaAsignada(idVentanilla: idVentanilla, idEmpleado: idEmpleado))
        let estado = try await ventanillasEstado()   // verificación inmediata
        log("VERIFY ASIGNAR", "ventanillas=\(estado.count)")
        return (r, estado)
    }

    /// Hace el POST y además trae el estado para verificar
    func liberar(idVentanilla: Int) async throws -> (APIMessageOK, [APIVentanillaEstado]) {
        let r: APIMessageOK = try await post(.ventanillaLiberar(idVentanilla: idVentanilla))
        APIService.AppEvents.shared.post(.ventanillaLiberada(idVentanilla: idVentanilla))
        let estado = try await ventanillasEstado()   // verificación inmediata
        log("VERIFY LIBERAR", "ventanillas=\(estado.count)")
        return (r, estado)
    }
}

// MARK: - Mapas a tus modelos UI
extension APIEmpleado {
    func toUIEmpleado() -> Empleado {
        Empleado(id: UUID(), nombre: nombre, disponible: true)
    }
}
extension APIVentanillaEstado {
    func toUIVentanilla() -> Ventanilla {
        Ventanilla(id: idVentanilla, nombreEmpleado: nombreEmpleado, ocupada: (idEmpleado != nil))
    }
}


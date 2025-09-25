//
//  VentanillasAPI.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation

enum VentanillasAPI {
    static func cargarEstado() async throws -> [Ventanilla] {
        let data = try await APIService.shared.ventanillasEstado()
        return data.map { $0.toUIVentanilla() }
    }

    static func liberar(idVentanilla: Int) async throws {
        _ = try await APIService.shared.liberar(idVentanilla: idVentanilla)
    }

    static func asignar(idVentanilla: Int, idEmpleado: Int) async throws {
        _ = try await APIService.shared.asignar(idVentanilla: idVentanilla, idEmpleado: idEmpleado)
    }
}

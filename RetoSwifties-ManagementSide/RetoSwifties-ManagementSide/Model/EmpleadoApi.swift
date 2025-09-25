//
//  EmpleadoApi.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation

struct EmpleadoAPI: Identifiable, Codable, Hashable {
    let idEmpleado: Int
    var nombre: String
    var rol: String
    var isDisponible: Bool

    enum CodingKeys: String, CodingKey {
        case idEmpleado
        case nombre
        case rol = "Rol"
        case isDisponible
    }

    // Identifiable para SwiftUI
    var id: Int { idEmpleado }
}

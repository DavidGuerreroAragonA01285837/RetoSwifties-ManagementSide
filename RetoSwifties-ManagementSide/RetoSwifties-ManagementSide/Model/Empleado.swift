//
//  Empleado.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation

struct Empleado: Identifiable, Hashable, Codable {
    let id: Int
    var nombre: String
    var disponible: Bool
}

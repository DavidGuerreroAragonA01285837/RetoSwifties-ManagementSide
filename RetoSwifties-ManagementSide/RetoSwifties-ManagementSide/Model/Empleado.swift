//
//  Empleado.swift
//  RetoSwifties-ManagementSide
//
//  Created by Elian Genc on 9/25/25.
//

import Foundation


struct Empleado: Codable, Hashable {
    var nombre: String
    var Contrasena: String
    var Rol: String
}

struct LoginResponse: Codable {
    let login: Bool
    let rol: String
}

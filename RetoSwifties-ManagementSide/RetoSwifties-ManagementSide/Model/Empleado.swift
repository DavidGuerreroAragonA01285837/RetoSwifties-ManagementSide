//
//  Empleado.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation

struct Empleado: Identifiable, Hashable, Codable {
    let id: UUID
    var nombre: String
    var disponible: Bool

    init(id: UUID = .init(), nombre: String, disponible: Bool = true) {
        self.id = id
        self.nombre = nombre
        self.disponible = disponible
    }
}

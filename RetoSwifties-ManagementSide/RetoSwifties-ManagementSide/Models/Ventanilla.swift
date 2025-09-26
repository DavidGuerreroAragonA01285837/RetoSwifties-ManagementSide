//
//  Ventanilla.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import Foundation

struct Ventanilla: Identifiable, Equatable {
    let id: Int
    var nombreEmpleado: String?
    var ocupada: Bool

    init(id: Int, nombreEmpleado: String? = nil, ocupada: Bool = false) {
        self.id = id
        self.nombreEmpleado = nombreEmpleado
        self.ocupada = ocupada
    }
}



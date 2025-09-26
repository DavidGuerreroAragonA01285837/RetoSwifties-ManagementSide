//
//  Empleado2.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation

// model/Empleado.swift
struct EmpleadoResponse: Identifiable, Codable, Hashable {
    var id: String { "\(nombre)_\(turnDate)" }
    var nombre: String
    var total_atendidos: Int
    var turnDate: String
    
    init(nombre: String, total_atendidos: Int,turnDate:String) {
        self.nombre = nombre
        self.total_atendidos = total_atendidos
        self.turnDate = turnDate
    }
}

// model/Empleado.swift
struct EmpleadoD: Identifiable, Hashable, Codable {
    var id: String {nombre}
    var nombre: String
    var semanas: [Int]
    
    var total_atendidos: Int { semanas.reduce(0, +) }
    var avg: Float {
        guard !semanas.isEmpty else { return 0 }
        return Float(total_atendidos) / Float(semanas.count)
    }
    
    init(from response: EmpleadoResponse) {
        self.nombre = response.nombre
        self.semanas = [response.total_atendidos]
    }
    init(nombre: String, semanas: [Int]) {
            self.nombre = nombre
            self.semanas = semanas
        }
}

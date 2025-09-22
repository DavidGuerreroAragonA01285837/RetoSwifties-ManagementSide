//
//  Empleado.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation

struct Empleado: Identifiable, Hashable{
    var id : Int
    var nombre : String
    var apellido : String
    var semanas: [Int]
        
    var total_atendidos: Int { semanas.reduce(0, +) }
    var avg: Float {
        guard !semanas.isEmpty else { return 0 }
        return Float(total_atendidos) / Float(semanas.count)
    }
    
    init(id: Int, nombre: String, apellido: String,semanas:Array<Int>){
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.semanas = semanas
    }
}

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
    var dias: [Int]
        
    var total_atendidos: Int { dias.reduce(0, +) }
    var avg: Float {
        guard !dias.isEmpty else { return 0 }
        return Float(total_atendidos) / Float(dias.count)
    }
    
    init(id: Int, nombre: String, apellido: String,dias:Array<Int>){
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.dias = dias
    }
}

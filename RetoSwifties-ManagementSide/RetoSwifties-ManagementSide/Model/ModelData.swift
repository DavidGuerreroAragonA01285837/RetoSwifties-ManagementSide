//
//  ModelData.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation

var listaEmpleados = obtenerEmpleados()

func obtenerEmpleados() -> Array<Empleado> {
    var listaEmpleados: Array<Empleado> = []
    
    listaEmpleados = [
      Empleado(
        id: 1,
        nombre: "Emilio",
        apellido: "Barragan",
        semanas:[10,13,20,18,21,9,6]
      ),
      Empleado(
        id: 2,
        nombre: "Rodrigo",
        apellido: "Vela",
        semanas: [7,3,10,9,12,9,13]
      ),
      Empleado(
        id: 3,
        nombre: "Andres",
        apellido: "Canavati",
        semanas: [9,14,8,23,2,7,1]
      ),
      Empleado(
        id: 4,
        nombre: "Elian",
        apellido: "Genc",
        semanas: [20,3,3,16,23,11,5]
      ),
    ];

    
    return listaEmpleados
}

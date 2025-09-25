//
//  RetoSwifties_ManagementSideApp.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

@main
struct RetoSwifties_ManagementSideApp: App {
    var body: some Scene {
        WindowGroup {
            let response1 = EmpleadoResponse(nombre: "Emilio", total_atendidos: 20, turnDate: "2025-09-23")
            let response2 = EmpleadoResponse(nombre: "David", total_atendidos: 15, turnDate: "2025-09-23")
            let response3 = EmpleadoResponse(nombre: "Rodrigo", total_atendidos: 10, turnDate: "2025-09-23")
            
            let empleados = [Empleado(from: response1), Empleado(from: response2), Empleado(from: response3)]
            
            return DashboardView(
                empleado: empleados[0],
                listaEmpleados: empleados
            )
        }
    }
}

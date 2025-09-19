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
            ContentView(empleado: Empleado(
                id: 1,
                nombre: "Emilio",
                apellido: "Barragan",
                dias: [10,13,20,18,21,9,6]
              ))
        }
    }
}

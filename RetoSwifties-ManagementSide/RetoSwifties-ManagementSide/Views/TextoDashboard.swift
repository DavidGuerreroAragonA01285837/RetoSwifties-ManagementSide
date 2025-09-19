//
//  TextoDashboard.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct TextoDashboard: View {
    @Binding var empleado: Empleado
    let empleados = listaEmpleados
    
    var body: some View {
        // Título más grande
        Text("Dashboard")
            .font(.system(size: 50, weight: .bold))
            .padding(.top, 40)

        // Picker que actualiza el empleado seleccionado
        Picker("Empleado", selection: $empleado) {
            ForEach(empleados) { emp in
                Text(emp.nombre).tag(emp)
            }
        }
        .pickerStyle(.menu)
        .frame(width: 300, height: 60)
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(15)
        .font(.largeTitle)

        // Botón con nombre del empleado actual
        Button(action: {}) {
            Text("\(empleado.nombre) \(empleado.apellido)")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(Color.orange)
                .cornerRadius(12)
        }
        .frame(width: 350)
        .padding(.top, 10)
    }
}


#Preview {
    TextoDashboard(
            empleado: .constant(
                Empleado(
                    id: 1,
                    nombre: "Emilio",
                    apellido: "Barragan",
                    dias: [10, 13, 20, 18, 21, 9, 6]
                )
            )
        )
}

//
//  EmpleadoRow.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct EmpleadoRow: View {
    let empleado: Empleado
    let onAsignar: () -> Void

    var body: some View {
        HStack {
            Text(empleado.nombre)
                .lineLimit(1)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer()

            Button(action: onAsignar) {
                Text("ASIGNAR")
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color(red: 45/255, green: 146/255, blue: 180/255)) // ← texto azul
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(red: 45/255, green: 146/255, blue: 180/255), lineWidth: 1) // ← borde azul
                    )
            }
            .buttonStyle(.plain)

        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EmpleadoRow(
        empleado: Empleado(nombre: "Juan Pérez"), // empleado mock
        onAsignar: {} // acción vacía
    )
}


//
//  EmpleadoRow.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct EmpleadoRow: View {
    let empleado: Empleado
    var disabled: Bool = false
    let onAsignar: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(empleado.nombre)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            Button(action: onAsignar) {
                Text("ASIGNAR")
                    .font(.system(size: 17, weight: .bold))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .foregroundColor(Color(red: 45/255, green: 146/255, blue: 180/255))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 45/255, green: 146/255, blue: 180/255), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            .disabled(disabled)
            .opacity(disabled ? 0.45 : 1.0)
            .accessibilityLabel("Asignar a \(empleado.nombre)")
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(spacing: 0) {
        EmpleadoRow(
            empleado: Empleado(id: UUID(), nombre: "Andrés Canavati"),
            disabled: false
        ) { }
        Divider()
        EmpleadoRow(
            empleado: Empleado(id: UUID(), nombre: "María López"),
            disabled: true
        ) { }
    }
    .padding()
    .background(Color(white: 0.98))
}




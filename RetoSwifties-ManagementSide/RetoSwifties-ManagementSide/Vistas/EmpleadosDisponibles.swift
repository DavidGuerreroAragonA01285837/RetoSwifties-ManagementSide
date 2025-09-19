//
//  EmpleadosDisponibles.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct EmpleadosDisponiblesSection: View {
    @StateObject private var vm = EmpleadosVM()
    var onAsignar: ((Empleado) -> Void)? = nil   // callback al padre

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Empleados disponibles")
                .font(.title3).bold()
                .foregroundStyle(Color.black.opacity(0.75))

            BuscarField(text: $vm.query)

            VStack(spacing: 0) {
                ForEach(vm.filtrados) { emp in
                    EmpleadoRow(empleado: emp) {
                        vm.asignar(emp)         // actualiza localmente
                        onAsignar?(emp)         // notifica al padre (opcional)
                    }
                    .padding(.horizontal, 10)

                    if emp.id != vm.filtrados.last?.id {
                        Divider().opacity(0.2)
                    }
                }

                if vm.filtrados.isEmpty {
                    Text("Sin resultados")
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 12)
                }
            }
            .padding(.vertical, 6)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.12), lineWidth: 1)
            )
        }
        .padding(.horizontal, 12)
        .onAppear { vm.resetDemo() }
    }
}


#Preview {
    EmpleadosDisponiblesSection { empleado in
        print("Asignado en preview: \(empleado.nombre)")
    }
}

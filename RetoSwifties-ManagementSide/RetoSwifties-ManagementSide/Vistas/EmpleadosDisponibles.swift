//
//  EmpleadosDisponibles.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct EmpleadosDisponiblesSection: View {
    @StateObject private var vm = EmpleadosVM()

    /// Cuando es true, se deshabilita el botón "ASIGNAR" (flujo bloqueado hasta elegir ventanilla)
    var isBloqueado: Bool = false

    /// Callback cuando se toca "ASIGNAR" en un empleado
    var onAsignar: ((Empleado) -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Empleados disponibles")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                .padding(.horizontal, 20)

            // Buscador: bindeado DIRECTO al @Published query de la VM
            HStack {
                BuscarField(text: $vm.query)
                    .frame(height: 42)
                    .padding(.horizontal, 20)
            }

            // Lista filtrada por vm.query
            VStack(spacing: 0) {
                ForEach(vm.filtrados) { emp in
                    EmpleadoRow(
                        empleado: emp,
                        disabled: isBloqueado
                    ) {
                        // Seguridad: si está bloqueado, no dispares nada
                        guard !isBloqueado else { return }

                        // Marca en la VM si quieres reflejar "tomado"
                        vm.asignar(emp)

                        // Notifica al padre (Admin) para activar modoAsignar
                        onAsignar?(emp)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)

                    Divider()
                        .padding(.leading, 20)
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
            .padding(.horizontal, 20)

            if isBloqueado {
                Text("Asignación en curso: selecciona una ventanilla para completar.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 22)
                    .padding(.top, 4)
            }
        }
        .padding(.top, 6)
        .onAppear {
            // Si usas datos demo, inicializa aquí
            vm.resetDemo()
        }
    }
}

#Preview {
    EmpleadosDisponiblesSection(isBloqueado: false) { _ in }
}


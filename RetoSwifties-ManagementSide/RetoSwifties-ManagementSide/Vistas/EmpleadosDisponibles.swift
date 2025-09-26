//
//  EmpleadosDisponibles.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI
import Combine

struct EmpleadosDisponibles: View {
    @StateObject private var vm = EmpleadosVM()
    var bloqueado: Bool = false
    var onElegir: (Empleado) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Empleados disponibles")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                .padding(.horizontal, 20)

            HStack {
                BuscarField(text: $vm.query)
                    .frame(height: 42)
                    .padding(.horizontal, 20)
            }

            VStack(spacing: 0) {
                ForEach(vm.filtrados) { emp in
                    EmpleadoRow(
                        empleado: emp,
                        disabled: bloqueado
                    ) {
                        guard !bloqueado else { return }
                        onElegir(emp)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)

                    Divider().padding(.leading, 20)
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.08), lineWidth: 1))
            .padding(.horizontal, 20)

            if bloqueado {
                Text("Asignación en curso: toca una ventanilla para completar.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 22)
                    .padding(.top, 4)
            }
        }
        .padding(.top, 6)
        .onAppear { Task { await vm.reloadDesdeAPI(query: nil) } }
    }
}

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

            // BuscarField está en su archivo propio
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
                        onElegir(emp)               // La vista Admin completa la asignación
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

#Preview {
    EmpleadosDisponibles(bloqueado: false) { _ in }
}

// MARK: - ViewModel embebido (sin UI, no afecta lo visual)
final class EmpleadosVM: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var empleados: [Empleado] = []
    @Published private(set) var filtrados: [Empleado] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Debounce para búsqueda remota
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] q in
                guard let self = self else { return }
                Task { await self.reloadDesdeAPI(query: q.isEmpty ? nil : q) }
            }
            .store(in: &cancellables)

        // Cuando asignen/liberen, refrescamos la lista
        AppEvents.shared.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task { await self.reloadDesdeAPI(query: self.query.isEmpty ? nil : self.query) }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func reloadDesdeAPI(query: String?) async {
        do {
            let lista = try await APIService.shared.empleadosDisponibles(query: query)
            empleados = lista
            filtrados = lista
        } catch {
            print("ERROR empleados_disponibles: \(error)")
        }
    }

    // Compat: algunas vistas llamaban vm.filtrar(newValue)
    func filtrar(_ texto: String) {
        Task { await reloadDesdeAPI(query: texto.isEmpty ? nil : texto) }
    }
}




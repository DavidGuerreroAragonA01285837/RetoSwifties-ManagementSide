//
//  EmpleadoVM.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 25/09/25.
//

import Foundation
import Combine

@MainActor
final class EmpleadosVM: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var empleados: [Empleado] = []
    @Published private(set) var filtrados: [Empleado] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Búsqueda reactiva con debounce
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] q in
                guard let self = self else { return }
                Task { await self.reloadDesdeAPI(query: q.isEmpty ? nil : q) }
            }
            .store(in: &cancellables)

        // Escucha eventos globales para refrescar
        AppEvents.shared.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task { await self.reloadDesdeAPI(query: self.query.isEmpty ? nil : self.query) }
            }
            .store(in: &cancellables)
    }

    func reloadDesdeAPI(query: String?) async {
        do {
            let lista = try await APIService.shared.empleadosDisponibles(query: query)
            empleados = lista
            filtrados = lista
        } catch {
            // Aquí podrías manejar errores si quieres, pero sin prints
        }
    }

    func filtrar(_ texto: String) {
        Task { await reloadDesdeAPI(query: texto.isEmpty ? nil : texto) }
    }
}

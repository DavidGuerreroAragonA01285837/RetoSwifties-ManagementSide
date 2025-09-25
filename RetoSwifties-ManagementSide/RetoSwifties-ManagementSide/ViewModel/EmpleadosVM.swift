//
//  EmpleadosVM.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation
import Combine

final class EmpleadosVM: ObservableObject {

    // MARK: - Inputs
    @Published var query: String = ""

    // MARK: - Outputs (compat)
    @Published private(set) var empleados: [Empleado] = []
    @Published private(set) var filtrados: [Empleado] = []

    // UUID(UI) -> idEmpleado(Int backend)
    private var apiIdPorUIId: [UUID: Int] = [:]

    // Ventanilla objetivo para modo compat 1 parámetro
    @Published var ventanillaObjetivo: Int? = nil

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init() {
        // 1) Carga inicial
        Task { await reloadDesdeAPI(query: nil) }

        // 2) Debounce del buscador -> backend
        $query
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] q in
                guard let self = self else { return }
                Task { await self.reloadDesdeAPI(query: q.isEmpty ? nil : q) }
            }
            .store(in: &cancellables)

        // 3) Suscripción a eventos del API (asignar / liberar) -> recarga disponibles
        APIService.AppEvents.shared.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .ventanillaAsignada, .ventanillaLiberada:
                    Task { await self.reloadDesdeAPI(query: self.query.isEmpty ? nil : self.query) }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Carga desde API
    @MainActor
    func reloadDesdeAPI(query: String?) async {
        do {
            let lista = try await APIService.shared.empleadosDisponibles(query: query)
            var nuevos: [Empleado] = []
            var indice: [UUID: Int] = [:]
            nuevos.reserveCapacity(lista.count)

            for api in lista {
                let ui = api.toUIEmpleado()
                nuevos.append(ui)
                indice[ui.id] = api.idEmpleado
            }

            self.empleados = nuevos
            self.filtrados = nuevos
            self.apiIdPorUIId = indice
        } catch {
            print("ERROR empleados_disponibles: \(error)")
        }
    }

    // MARK: - Compat: algunas vistas llaman vm.filtrar(newValue)
    func filtrar(_ texto: String) {
        Task { await reloadDesdeAPI(query: texto.isEmpty ? nil : texto) }
    }

    // Utilitario para fijar ventanilla objetivo cuando tu flujo la sabe antes
    func setVentanillaObjetivo(_ id: Int?) { self.ventanillaObjetivo = id }

    // MARK: - ASIGNAR (todas las sobrecargas)

    /// Firma “oficial”: usando UUID del modelo UI + id de ventanilla
    @MainActor
    func asignar(empleadoUI uiId: UUID, aVentanilla idVentanilla: Int) async throws {
        guard let idEmpleado = apiIdPorUIId[uiId] else {
            throw NSError(domain: "EmpleadosVM", code: 404,
                          userInfo: [NSLocalizedDescriptionKey: "No tengo idEmpleado real para este empleado"])
        }
        let _ = try await APIService.shared.asignar(idVentanilla: idVentanilla, idEmpleado: idEmpleado)
        // No espero a eventos: fuerzo recarga inmediata para ver el cambio
        await reloadDesdeAPI(query: self.query.isEmpty ? nil : self.query)
    }

    /// Overload sin labels (compat: vm.asignar(empUUID, ventId))
    @MainActor
    func asignar(_ empleadoUI: UUID, _ aVentanilla: Int) async throws {
        try await asignar(empleadoUI: empleadoUI, aVentanilla: aVentanilla)
    }

    /// Overload que recibe Empleado (compat: vm.asignar(empleado, ventId))
    @MainActor
    func asignar(_ empleado: Empleado, _ idVentanilla: Int) async throws {
        try await asignar(empleadoUI: empleado.id, aVentanilla: idVentanilla)
    }

    /// Overload con label para Empleado (compat: vm.asignar(empleado, aVentanilla:))
    @MainActor
    func asignar(_ empleado: Empleado, aVentanilla idVentanilla: Int) async throws {
        try await asignar(empleadoUI: empleado.id, aVentanilla: idVentanilla)
    }

    // Wrappers “sync” para vistas que no soportan async/throws (1 solo parámetro)
    @MainActor
    func asignar(_ empleado: Empleado) {
        Task {
            do {
                guard let v = ventanillaObjetivo else { return }
                try await self.asignar(empleadoUI: empleado.id, aVentanilla: v)
            } catch { print("Error asignar empleado: \(error)") }
        }
    }

    @MainActor
    func asignar(_ empleadoUI: UUID) {
        Task {
            do {
                guard let v = ventanillaObjetivo else { return }
                try await self.asignar(empleadoUI: empleadoUI, aVentanilla: v)
            } catch { print("Error asignar empleado: \(error)") }
        }
    }
}

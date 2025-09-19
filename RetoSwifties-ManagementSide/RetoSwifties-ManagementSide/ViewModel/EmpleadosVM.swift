//
//  EmpleadosVM.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation

@MainActor
final class EmpleadosVM: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var empleados: [Empleado] = []

    // Datos locales
    private var base: [Empleado] = [
        .init(nombre: "Juan Perez"),
        .init(nombre: "María Lopez"),
        .init(nombre: "Pedro Ruiz"),
        .init(nombre: "Ana Torres"),
        .init(nombre: "Rodrigo Vela"),
        .init(nombre: "Elian Genc")
    ]

    init() { empleados = base }

    var filtrados: [Empleado] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let disponibles = base.filter { $0.disponible }
        guard !q.isEmpty else { return disponibles }
        return disponibles.filter { $0.nombre.lowercased().contains(q) }
    }

    func asignar(_ empleado: Empleado) {
        guard let idx = base.firstIndex(where: { $0.id == empleado.id }) else { return }
        base[idx].disponible = false
        empleados = base
    }

    func resetDemo() {
        base = base.map { Empleado(id: $0.id, nombre: $0.nombre, disponible: true) }
        empleados = base
        query = ""
    }
}

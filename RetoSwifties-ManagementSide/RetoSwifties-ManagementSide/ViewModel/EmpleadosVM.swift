//
//  EmpleadosVM.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import Foundation
import Combine

final class EmpleadosVM: ObservableObject {
    @Published var query: String = ""
    @Published private(set) var empleados: [Empleado] = []

    // Si Empleado.id es UUID:
    private var ocupados = Set<UUID>()
    // Si Empleado.id es Int, usa: private var ocupados = Set<Int>()

    // Lista dinámica según query y ocupados
    var filtrados: [Empleado] {
        empleados.filter { emp in
            let disponible = !ocupados.contains(emp.id)
            let coincide = query.isEmpty || emp.nombre.localizedCaseInsensitiveContains(query)
            return disponible && coincide
        }
    }

    // Marcar como ocupado al asignar
    func asignar(_ e: Empleado) {
        ocupados.insert(e.id)
        objectWillChange.send()
    }

    // Devolver por nombre (porque Ventanilla guarda el nombre)
    func devolverPorNombre(_ nombre: String) {
        guard let e = empleados.first(where: { $0.nombre == nombre }) else { return }
        ocupados.remove(e.id)
        objectWillChange.send()
    }

    // Demo opcional
    func resetDemo() {
        empleados = [
            Empleado(id: UUID(), nombre: "Andrés Canavati"),
            Empleado(id: UUID(), nombre: "Elian Genc"),
            Empleado(id: UUID(), nombre: "Rodrigo Vela"),
            Empleado(id: UUID(), nombre: "Daniela Ruiz"),
            Empleado(id: UUID(), nombre: "María López"),
        ]
        ocupados.removeAll()
    }
}


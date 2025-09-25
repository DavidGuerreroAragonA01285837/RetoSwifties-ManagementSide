//
//  VentanillaGrid.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct VentanillaGrid: View {
    let ventanillas: [Ventanilla]
    var enModoLiberar: Bool = false
    var onTapCard: (Ventanilla) -> Void

    private let columnas = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        LazyVGrid(columns: columnas, spacing: 12) {
            ForEach(ventanillas) { v in
                VentanillaCard(
                    ventanilla: v,
                    enModoLiberar: enModoLiberar,
                    onTap: { onTapCard(v) }
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    VentanillaGrid(
        ventanillas: [
            Ventanilla(id: 1, nombreEmpleado: "Andrés Canavati", ocupada: true),
            Ventanilla(id: 2, ocupada: false),
            Ventanilla(id: 3, ocupada: false),
            Ventanilla(id: 4, nombreEmpleado: "Elian Genc", ocupada: true)
        ],
        onTapCard: { _ in }
    )
    .padding()
}

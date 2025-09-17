//
//  VentanillaGrid.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct VentanillaGrid: View {
    var ventanillas: [Ventanilla]
    var enModoLiberar: Bool = false
    var onTapCard: (Ventanilla) -> Void = { _ in }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(ventanillas) { v in
                VentanillaCard(
                    ventanilla: v,
                    enModoLiberar: enModoLiberar,
                    onTap: { onTapCard(v) }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

#Preview {
    VentanillaGrid(ventanillas: [
        Ventanilla(id: 1, nombreEmpleado: "Andres Canavati", ocupada: true),
        Ventanilla(id: 2, ocupada: false),
        Ventanilla(id: 3, ocupada: false),
        Ventanilla(id: 4, nombreEmpleado: "Elian Genc", ocupada: true)
    ])
}


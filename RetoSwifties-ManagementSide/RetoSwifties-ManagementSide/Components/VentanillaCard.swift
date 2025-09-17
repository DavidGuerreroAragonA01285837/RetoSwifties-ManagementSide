//
//  VentanillaCard.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct VentanillaCard: View {
    var ventanilla: Ventanilla
    var enModoLiberar: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        let bgColor = ventanilla.ocupada
            ? Color(red: 0/255, green: 104/255, blue: 138/255)   // #01688A
            : Color(red: 153/255, green: 153/255, blue: 153/255) // #999999

        VStack(spacing: 6) {
            Text("Ventanilla \(ventanilla.id)")
                .font(.system(size: 34, weight: .bold))
                .fontWeight(.bold).foregroundColor(.white)

            if ventanilla.ocupada, let empleado = ventanilla.nombreEmpleado {
                Text(empleado)
                    .font(.title).fontWeight(.semibold).foregroundColor(.white)
                    .lineLimit(1).minimumScaleFactor(0.8)
                
            }
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(bgColor))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(enModoLiberar ? Color.white.opacity(0.8) : .clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
        .onTapGesture { onTap?() }
    }
}


#Preview {
    VStack(spacing: 16) {
        VentanillaCard(
            ventanilla: Ventanilla(id: 1, nombreEmpleado: "Andres Canavati", ocupada: true)
        )
        VentanillaCard(
            ventanilla: Ventanilla(id: 2, ocupada: false)
        )
    }
    .padding()
}




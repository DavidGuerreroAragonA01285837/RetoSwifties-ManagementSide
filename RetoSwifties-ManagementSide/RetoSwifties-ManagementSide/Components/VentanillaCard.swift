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
            ? Color(red: 0/255, green: 104/255, blue: 138/255)
            : Color(red: 153/255, green: 153/255, blue: 153/255)

        VStack(spacing: 10) {
            if ventanilla.ocupada, let empleado = ventanilla.nombreEmpleado {
                Text(empleado)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)

                Text("Ventanilla \(ventanilla.id)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)

            } else {
                Text("Libre")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.center)

                Text("Ventanilla \(ventanilla.id)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding(20)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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




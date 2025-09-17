//
//  Admin.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct Admin: View {
    @State private var ventanillas: [Ventanilla] = [
        Ventanilla(id: 1, nombreEmpleado: "Andrés Canavati", ocupada: true),
        Ventanilla(id: 2, nombreEmpleado: "Elian Genc", ocupada: true),
        Ventanilla(id: 3, nombreEmpleado: "Rodrigo Vela", ocupada: true),
        Ventanilla(id: 4, ocupada: false),
        Ventanilla(id: 5, nombreEmpleado: "Daniela Ruiz", ocupada: true),
        Ventanilla(id: 6, ocupada: false),
        Ventanilla(id: 7, nombreEmpleado: "María López", ocupada: true),
        Ventanilla(id: 8, ocupada: false)
    ]
    @State private var modoLiberar = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Asignación de ventanillas")
                .font(.system(size: 55, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))

            if modoLiberar {
                Text("Toca una ventanilla ocupada para liberarla")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
            }

            VentanillaGrid(
                ventanillas: ventanillas,
                enModoLiberar: modoLiberar,
                onTapCard: { v in
                    if modoLiberar, v.ocupada {
                        liberar(id: v.id)
                        modoLiberar = false
                    }
                }
            )

            Button {
                withAnimation(.easeInOut) { modoLiberar.toggle() }
            } label: {
                Text(modoLiberar ? "Cancelar liberación" : "Liberar ventanillas")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: 400)
                    .padding(.vertical, 18) // menos alto
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(modoLiberar ? .black.opacity(0.7) : .orange)
                    )
            }

            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .padding(.top, 16)
        }//Cierre Vstack
        .frame(maxHeight: .infinity, alignment: .top) // <- obliga a que todo inicie arriba
    } // Cierre View
    

    private func setOcupada(id: Int, nombre: String) {
        guard let i = ventanillas.firstIndex(where: { $0.id == id }) else { return }
        ventanillas[i].ocupada = true
        ventanillas[i].nombreEmpleado = nombre
    }

    private func liberar(id: Int) {
        guard let i = ventanillas.firstIndex(where: { $0.id == id }) else { return }
        ventanillas[i].ocupada = false
        ventanillas[i].nombreEmpleado = nil
    }
}

#Preview {
    Admin()
}


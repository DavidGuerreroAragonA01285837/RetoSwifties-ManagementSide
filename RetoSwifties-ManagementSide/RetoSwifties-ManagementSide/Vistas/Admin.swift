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
    @State private var modoAsignar = false                   // ← NUEVO
    @State private var empleadoPendiente: Empleado? = nil    // ← NUEVO

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Título
                Text("Asignación de ventanillas")
                    .font(.system(size: 55, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))

                // Mensajes de modo
                if modoLiberar {
                    Text("Toca una ventanilla ocupada para liberarla")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                }
                if modoAsignar, let emp = empleadoPendiente {
                    ModoBanner(texto: "Selecciona una ventanilla para asignar a \(emp.nombre)")
                }

                // Grid con realce cuando estamos asignando
                VentanillaGrid(
                    ventanillas: ventanillas,
                    enModoLiberar: modoLiberar,
                    onTapCard: { v in
                        if modoLiberar, v.ocupada {
                            liberar(id: v.id)
                            modoLiberar = false
                        } else if modoAsignar, let emp = empleadoPendiente {
                            // Asignamos aquí
                            if let i = ventanillas.firstIndex(where: { $0.id == v.id }) {
                                ventanillas[i].ocupada = true
                                ventanillas[i].nombreEmpleado = emp.nombre
                            }
                            // Salimos del modo asignar
                            empleadoPendiente = nil
                            withAnimation(.easeInOut) { modoAsignar = false }
                        }
                    }
                )

                // Botón liberar (deshabilitado en modo asignar)
                Button {
                    withAnimation(.easeInOut) { modoLiberar.toggle() }
                } label: {
                    Text(modoLiberar ? "Cancelar liberación" : "Liberar ventanillas")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: 400)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(modoLiberar ? .black.opacity(0.7) : .orange)
                        )
                }
                .disabled(modoAsignar) // ← clave para no mezclar flujos
                .opacity(modoAsignar ? 0.5 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .padding(.top, 8)

                // Sección inferior: ahora inicia el modo asignar
                EmpleadosDisponiblesSection { empleado in
                    // Cambiamos el flujo: primero eligen empleado → luego la card
                    empleadoPendiente = empleado
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        modoAsignar = true
                        modoLiberar = false
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.vertical, 16)
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func liberar(id: Int) {
        guard let i = ventanillas.firstIndex(where: { $0.id == id }) else { return }
        ventanillas[i].ocupada = false
        ventanillas[i].nombreEmpleado = nil
    }
}

private struct ModoBanner: View {
    let texto: String
    var body: some View {
        Text(texto)
            .font(.title3.weight(.semibold))
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0/255, green: 104/255, blue: 138/255)) // #01688A del “ocupado”
            )
            .padding(.horizontal, 20)
    }
}

#Preview{
    Admin()
}

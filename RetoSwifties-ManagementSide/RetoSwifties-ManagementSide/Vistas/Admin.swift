//
//  Admin.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//
//
//  Admin.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI
import Combine

struct Admin: View {
    // Estado que se muestra en la grid (ahora viene del API)
    @State private var ventanillas: [Ventanilla] = []

    // Estados de interacción (sin cambios visuales)
    @State private var modoLiberar = false
    @State private var modoAsignar = false
    @State private var empleadoPendiente: Empleado? = nil

    // Para escuchar eventos del API y refrescar
    @State private var cancellable: AnyCancellable?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
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
                if modoAsignar, let emp = empleadoPendiente {
                    ModoBanner(texto: "Selecciona una ventanilla para asignar a \(emp.nombre)")
                }

                VentanillaGrid(
                    ventanillas: ventanillas,
                    enModoLiberar: modoLiberar,
                    onTapCard: { v in
                        if modoLiberar, v.ocupada {
                            // LIBERAR vía API y refrescar
                            Task {
                                do {
                                    try await VentanillasAPI.liberar(idVentanilla: v.id)
                                    await cargarEstado()
                                } catch {
                                    print("Error al liberar ventanilla \(v.id): \(error)")
                                }
                            }
                            modoLiberar = false
                        } else if modoAsignar, let emp = empleadoPendiente {
                            // ASIGNAR: resolvemos idEmpleado real y posteamos
                            Task {
                                do {
                                    if let idEmpleado = try await resolverIdEmpleadoPorNombre(emp.nombre) {
                                        _ = try await APIService.shared.asignar(idVentanilla: v.id, idEmpleado: idEmpleado)
                                        await cargarEstado()
                                    } else {
                                        print("No encontré idEmpleado para '\(emp.nombre)' en disponibles.")
                                    }
                                } catch {
                                    print("Error al asignar \(emp.nombre) a ventanilla \(v.id): \(error)")
                                }
                            }
                            empleadoPendiente = nil
                            withAnimation(.easeInOut) { modoAsignar = false }
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
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(modoLiberar ? .black.opacity(0.7) : .orange)
                        )
                }
                .disabled(modoAsignar)
                .opacity(modoAsignar ? 0.5 : 1.0)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .padding(.top, 8)

                // Mantengo tu sección tal cual; solo uso el callback
                EmpleadosDisponiblesSection(
                    isBloqueado: modoAsignar
                ) { empleado in
                    // Evitar taps repetidos si ya estamos en asignación
                    if modoAsignar { return }

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
        .onAppear {
            // Carga inicial del estado del backend
            Task { await cargarEstado() }

            // Suscribirse a eventos del bus (asignar/liberar) para refrescar automáticamente
            cancellable = APIService.AppEvents.shared.publisher
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    Task { await cargarEstado() }
                }
        }
        .onDisappear {
            cancellable?.cancel()
            cancellable = nil
        }
    }

    // MARK: - Helpers

    /// Trae el estado real de las ventanillas desde el API y mapea a tu modelo UI
    @MainActor
    private func cargarEstado() async {
        do {
            ventanillas = try await VentanillasAPI.cargarEstado()
        } catch {
            print("Error cargando ventanillas: \(error)")
        }
    }

    /// Resuelve el idEmpleado (Int backend) a partir del nombre mostrado.
    /// Sin tocar vistas: aprovechamos el endpoint de disponibles con query por nombre.
    private func resolverIdEmpleadoPorNombre(_ nombre: String) async throws -> Int? {
        let lista = try await APIService.shared.empleadosDisponibles(query: nombre)
        // Elegimos el que coincida exacto primero; si no, tomamos el primero de la lista
        return lista.first(where: { $0.nombre == nombre })?.idEmpleado ?? lista.first?.idEmpleado
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
                    .fill(Color(red: 0/255, green: 104/255, blue: 138/255))
            )
            .padding(.horizontal, 20)
    }
}

#Preview { Admin() }

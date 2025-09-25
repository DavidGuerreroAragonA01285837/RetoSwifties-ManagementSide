//
//  Admin.swift
//  RetoSwifties
//
//  Created by Alumno on 17/09/25.
//
import SwiftUI
import Combine

struct Admin: View {
    @State private var ventanillas: [Ventanilla] = []
    @State private var modoLiberar = false
    @State private var empleadoSeleccionado: Empleado? = nil

    @State private var eventsCancellable: AnyCancellable?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Encabezado (respeta tu estilo existente)
                Text("Asignación de ventanillas")
                    .font(.system(size: 55, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))

                // Grid de ventanillas (usa tus sub-vistas tal cual)
                VentanillaGrid(
                    ventanillas: ventanillas,
                    enModoLiberar: modoLiberar,
                    onTapCard: { v in
                        if modoLiberar, v.ocupada {
                            Task {
                                do { _ = try await APIService.shared.liberar(idVentanilla: v.id); await cargarEstado() }
                                catch { print("Error liberar \(v.id): \(error)") }
                            }
                            modoLiberar = false
                        } else if let emp = empleadoSeleccionado {
                            Task {
                                do { _ = try await APIService.shared.asignar(idVentanilla: v.id, idEmpleado: emp.id); await cargarEstado() }
                                catch { print("Error asignar \(emp.nombre) -> \(v.id): \(error)") }
                            }
                            empleadoSeleccionado = nil
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
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .opacity(empleadoSeleccionado == nil ? 1 : 0.6)
                .disabled(empleadoSeleccionado != nil)

                // Sección de empleados disponibles (usa tus sub-vistas externas)
                EmpleadosDisponibles(
                    bloqueado: empleadoSeleccionado != nil,
                    onElegir: { emp in
                        // Mantiene tu flujo: primero elegir empleado, luego tocar ventanilla
                        empleadoSeleccionado = emp
                        modoLiberar = false
                    }
                )
                .padding(.bottom, 30)
            }
            .padding(.vertical, 16)
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            Task { await cargarEstado() }
            eventsCancellable = AppEvents.shared.publisher
                .receive(on: DispatchQueue.main)
                .sink { _ in Task { await cargarEstado() } }
        }
        .onDisappear { eventsCancellable?.cancel(); eventsCancellable = nil }
    }

    @MainActor
    private func cargarEstado() async {
        do { ventanillas = try await APIService.shared.ventanillasEstado() }
        catch { print("Error cargar ventanillas: \(error)") }
    }
}

#Preview { Admin() }

//
//  SontentView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import SwiftUI
import Charts

struct sontentView: View {
    @State public var empleado: Empleado = Empleado(nombre: "Cargando...", semanas: [0,1,2,3])
    @State public var listaEmpleados: [Empleado] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                if !listaEmpleados.isEmpty {
                    // Título y selección de empleado
                    TextoDashboard(empleado: $empleado, empleados: listaEmpleados)
                    
                    // Gráfica de barras
                    GraficaBarra(empleado: $empleado)
                    
                    // Métricas
                    Metricas(empleado: $empleado)
                    
                    // Gráfico circular
                    GraficaPie(empleados: listaEmpleados, empleado: $empleado)
                } else {
                    Text("Cargando empleados...")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                EmpleadoService.shared.fetchEmpleadosAgrupados { empleados in
                    self.listaEmpleados = empleados
                    if let primero = empleados.first {
                        self.empleado = primero
                    }
                }
            }
        }
    }
}

#Preview {
    // Preview con placeholder
    sontentView()
}

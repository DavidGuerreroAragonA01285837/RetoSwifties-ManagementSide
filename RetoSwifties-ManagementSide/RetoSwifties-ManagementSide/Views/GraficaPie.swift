//
//  GraficaPie.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI
import Charts

struct GraficaPie: View {
    var empleados: [EmpleadoD]
    @Binding var empleado: EmpleadoD
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Clientes atendidos por \(empleado.nombre)")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)

            Chart {
                ForEach(empleados) { e in
                    SectorMark(
                        angle: .value("Total Atendidos", e.total_atendidos),
                        angularInset: 1
                    )
                    .foregroundStyle(
                        e.id == empleado.id
                        ? Color(red: 1/255, green: 104/255, blue: 138/255)
                        : Color(red: 255/255, green: 153/255, blue: 0/255)
                    )
                    .annotation(position: .overlay) {
                    }
                }
            }
            .frame(height: 230)
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.sRGB, red: 242/255, green: 242/255, blue: 242/255))
                .shadow(color: Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9), radius: 6, x: 0, y: 3)
        )
        .padding(.horizontal)
    }
}


#Preview {
    let response = EmpleadoResponse(
        nombre: "Emilio Barragan",
        total_atendidos: 20,
        turnDate: "2025-09-23"
    )
    GraficaPie(
        empleados: [EmpleadoD(from: response)],
        empleado: .constant(EmpleadoD(from: response))
    )
}


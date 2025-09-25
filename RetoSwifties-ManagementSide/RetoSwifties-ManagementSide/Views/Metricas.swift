//
//  Metricas.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct Metricas: View {
    @Binding var empleado: Empleado
    
    var body: some View {
        HStack(spacing: 40) {
            
            VStack(spacing: 8) {
                Text("Total Clientes")
                    .font(.subheadline)
                    .foregroundColor(Color(.sRGB, red: 102/255, green: 102/255, blue: 102/255))
                
                Text("\(empleado.total_atendidos)")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color(.sRGB, red: 102/255, green: 102/255, blue: 102/255))
            }
            
            VStack(spacing: 8) {
                let prom = String(format: "%.2f", empleado.avg)
                Text("Avg clientes/semana")
                    .font(.subheadline)
                    .foregroundColor(Color(.sRGB, red: 102/255, green: 102/255, blue: 102/255))
                
                Text("\(prom)")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color(.sRGB, red: 102/255, green: 102/255, blue: 102/255))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.sRGB, red: 242/255, green: 242/255, blue: 242/255)) // gris 242,242,242
                .shadow(color: Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9),
                        radius: 6, x: 0, y: 3)
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
    return Metricas(empleado: .constant(Empleado(from: response)))
}

//
//  GraficaBarra.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI
import Charts

struct GraficaBarra: View {
    //let dias = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]
    @Binding var empleado: EmpleadoD
    //@State public var clientes: [Int]
    //let clientes = [29,39,28,12,1,2,3]
    
    var body: some View {
        /**
        VStack(alignment: .leading) {
            Text("clientes/dia")
                .font(.headline)
            
            Chart {
                ForEach(0..<dias.count, id: \.self) { i in
                    BarMark(
                        x: .value("Día", dias[i]),
                        y: .value("Clientes", empleado.dias[i])
                    )
                    .foregroundStyle(Color(red: 255/255, green: 153/255, blue: 0/255))
                }
            }
            .frame(height: 300)
        }
         */
        VStack(alignment: .leading, spacing: 16) {
                    // Título
                    Text("Clientes por semana")
                        .font(.title2.bold())
                        .padding(.leading, 10)
                    
                    Chart {
                        ForEach(Array(empleado.semanas.enumerated()), id: \.offset) { index, total in
                            BarMark(
                                x: .value("Semana", "Semana \(index + 1)"),
                                y: .value("Clientes", total)
                            )
                            .foregroundStyle(
                                Color(.sRGB, red: 255/255, green: 153/255, blue: 0/255)
                            )
                            .cornerRadius(6)
                            
                            .annotation(position: .top) {
                                Text("\(total)")
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .bold()
                            }
                        }
                    }
                    .frame(height: 320)
                    .padding(.horizontal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.sRGB, red: 242/255, green: 242/255, blue: 242/255))
                        .shadow(color: Color(.sRGB, red: 242/255, green: 242/255, blue: 242/255), radius: 8, x: 0, y: 4)

                )
                .padding()
    }
}

#Preview {
    let response = EmpleadoResponse(
        nombre: "Emilio Barragan",
        total_atendidos: 20,
        turnDate: "2025-09-23"
    )
    return GraficaBarra(empleado: .constant(EmpleadoD(from: response)))
}

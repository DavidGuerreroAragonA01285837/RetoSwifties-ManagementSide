//
//  GraficaBarra.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI
import Charts

struct GraficaBarra: View {
    let dias = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]
    @Binding var empleado: Empleado
    //@State public var clientes: [Int]
    //let clientes = [29,39,28,12,1,2,3]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("clientes/dia")
                .font(.headline)
            
            Chart {
                ForEach(0..<dias.count, id: \.self) { i in
                    BarMark(
                        x: .value("Día", dias[i]),
                        y: .value("Clientes", empleado.dias[i])
                    )
                    .foregroundStyle(Color.orange)
                }
            }
            .frame(height: 300)
        }
    }
}

#Preview {
    GraficaBarra(empleado: .constant(
        Empleado(
            id: 1,
            nombre: "Emilio",
            apellido: "Barragan",
            dias: [10, 13, 20, 18, 21, 9, 6]
        )
    ))
}

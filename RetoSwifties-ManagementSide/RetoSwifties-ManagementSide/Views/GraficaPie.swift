//
//  GraficaPie.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI
import Charts

struct GraficaPie: View {
    var empleados: [Empleado]   // lista completa
    @Binding var empleado: Empleado // el seleccionado
    
    var body: some View {
        VStack {
            Text("Clientes atendidos por empleado")
                .font(.title2)
            
            Chart {
                ForEach(empleados) { e in
                    SectorMark(
                        angle: .value("Total Atendidos", e.total_atendidos),
                       // innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(e.id == empleado.id ? Color.blue : Color.orange) // azul si es el seleccionado
                   // .annotation(position: .overlay) {
                     //   Text("\(e.nombre.prefix(1))") // inicial
                       //     .font(.caption)
                         //   .foregroundColor(.white)
                    //}
                }
            }
            .frame(height: 300)
        }
    }
}


#Preview {
    GraficaPie(empleados:listaEmpleados,empleado: .constant(
        Empleado(
            id: 1,
            nombre: "Emilio",
            apellido: "Barragan",
            dias: [10, 13, 20, 18, 21, 9, 6]
        )
    ))
}

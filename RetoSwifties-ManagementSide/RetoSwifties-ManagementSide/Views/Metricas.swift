//
//  Metricas.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct Metricas: View {
    //@State public var totalClientes: Int
    //@State public var avgClientes: Float
    @Binding var empleado: Empleado
    var body: some View {
        HStack(spacing: 40) {
            VStack {
                Text("Total Clientes").font(.subheadline)
                   // .font(.system(size:40,weight: .bold))
                Text("\(empleado.total_atendidos)")
                    .font(.system(size:50,weight: .bold))
                    .bold()
            }
            
            VStack {
                Text("Avg clientes/dia").font(.subheadline)
                Text("\(empleado.avg)")
                    .font(.system(size:50,weight: .bold))
                    .bold()
            }
        }
    }
}

#Preview {
    Metricas(empleado: .constant(
        Empleado(
            id: 1,
            nombre: "Emilio",
            apellido: "Barragan",
            dias: [10, 13, 20, 18, 21, 9, 6]
        )
    ))
}

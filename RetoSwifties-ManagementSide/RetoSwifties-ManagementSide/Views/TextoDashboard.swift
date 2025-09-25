//
//  TextoDashboard.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct TextoDashboard: View {
    @Binding var empleado: Empleado
    //let empleados = listaEmpleados
    @State public var empleados: [Empleado]
    
    
    var body: some View {
        Text("Resumen de Empleados")
            .font(.system(size: 50, weight: .bold))
            //.padding(.top, 40)
            .foregroundColor(Color(.sRGB, red: 102/255, green: 102/255, blue: 102/255))

        Picker("Empleado", selection: $empleado) {
            ForEach(empleados) { emp in
                Text(emp.nombre).tag(emp)
            }
            .font(.system(size: 40, weight: .bold))
        }
        .tint(Color.orange)
        .pickerStyle(.menu)
        .frame(width: 170, height: 30)
        .padding()
        .background(Color(.sRGB, red: 211/255, green: 211/255, blue: 211/255))
        .cornerRadius(15)
        .font(.largeTitle)
        .font(.system(size: 40, weight: .bold))

        Text("\(empleado.nombre)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(Color.orange)
                .cornerRadius(12)
        .frame(width: 350)
        //.padding(.top, 10)
    }
}


#Preview {
    let response1 = EmpleadoResponse(nombre: "Emilio", total_atendidos: 20, turnDate: "2025-09-23")
    let response2 = EmpleadoResponse(nombre: "David", total_atendidos: 15, turnDate: "2025-09-23")
    let response3 = EmpleadoResponse(nombre: "Rodrigo", total_atendidos: 10, turnDate: "2025-09-23")
    
    let empleados = [Empleado(from: response1), Empleado(from: response2), Empleado(from: response3)]
    
    TextoDashboard(
        empleado: .constant(Empleado(from: response1)),
        empleados: empleados
    )
}

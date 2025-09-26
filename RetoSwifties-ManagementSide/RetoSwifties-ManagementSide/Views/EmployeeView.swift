//
//  AdminView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 26/09/25.
//

import SwiftUI

struct EmployeeView: View {
    var body: some View {
        TabView{
                
            
            AdminTurnosView(ventanillaNum: .constant(1))
                .tabItem{
                    Image(systemName:"deskComputer")
                    Text("Ventanilla")
                }
            
            Ajustes(idEmpleado: 1)
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Ajustes")
                }
        }
        
        
    }
}

#Preview {
    AdminView()
}

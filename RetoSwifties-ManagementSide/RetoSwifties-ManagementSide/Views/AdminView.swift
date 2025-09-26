//
//  AdminView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 26/09/25.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        TabView{
            
            Admin()
                .tabItem{
                    Image(systemName: "person")
                    Text("Administracion")
                }
            
            DashboardView()
                .tabItem{
                    Image(systemName: "rectangle.grid.2x2")
                    Text("Dashboard")
                }
                
            
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

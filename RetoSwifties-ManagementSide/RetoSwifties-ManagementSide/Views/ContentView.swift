//
//  ContentView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            
            NavigationLink("Go to Admin"){
                AdminView()
                    .navigationBarBackButtonHidden(true)
                
            }
            NavigationLink("Go to Employee"){
                EmployeeView()
                    .navigationBarBackButtonHidden(true)
                
            }
        }
        
    }
    }

#Preview {
    ContentView() 
}

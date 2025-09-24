//
//  ContentView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI

struct ContentView: View {
    @State var ventanillaNum = 1
    var body: some View {
        VStack {
            AdminTurnosView(ventanillaNum: $ventanillaNum)
        }
        .padding()
    }
}	
	
#Preview {
    ContentView()
}

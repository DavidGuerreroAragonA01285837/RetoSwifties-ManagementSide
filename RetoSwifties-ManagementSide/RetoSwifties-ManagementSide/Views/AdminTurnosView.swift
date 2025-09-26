//
//  AdminTurnosView.swift
//  RetoSwifties-ManagementSide
//
//  Created by David on 21/09/25.
//

import SwiftUI

struct AdminTurnosView: View {
    @Binding var ventanillaNum: Int
    @State var atendiendoAhora: Int = 0
    @StateObject var siguientesTurnos = TurnViewModel()
    var body: some View {
        VStack{
            Text("Ventanilla \(ventanillaNum)")
                .font(.system(size: 85))
                .foregroundStyle(Color(red:102/255, green: 102/255, blue: 102/255))
            Text("Turno actual")
                .font(.system(size: 50))
                .padding(.vertical, 10)
                .foregroundStyle(Color(red:102/255, green: 102/255, blue: 102/255))
            TurnNumberComponent(numeroTurno: $atendiendoAhora, size: 300,fontSize: 120.0)
            Button("Llamar Siguiente"){
                if (siguientesTurnos.turns != []){
                    siguientesTurnos.markTurnAsServed(serviceID: siguientesTurnos.turns[0].serviceID)
                }
                else{
                    siguientesTurnos.fetchTurns()
                    print(siguientesTurnos.fetchTurns())
                }
            }
            .buttonStyle(.borderedProminent)
            .font(.system(size: 50))
            .frame(width: 500)
            .tint(Color(red: 1/255, green: 104/255, blue: 138/255))
            .padding(.vertical,15)
            Text("Proximos Turnos")
                .font(.system(size: 30))
                .foregroundStyle(Color(red:102/255, green: 102/255, blue: 102/255))
            Divider()
                .frame(width: 250)
                .background(Color.black)
            List(siguientesTurnos.turns.dropFirst()){ elemento in
                Text("Turno \(elemento.turnNumber)")
                    .listRowSeparatorTint(.black, edges: .all)
            }
            .onAppear(){
                siguientesTurnos.fetchTurns()
            }
            .onChange(of: siguientesTurnos.turns) {
                // This closure runs every time vm.turns changes
                if siguientesTurnos.turns != []{
                    atendiendoAhora = siguientesTurnos.turns[0].turnNumber
                }
                else{
                    atendiendoAhora = 0
                }
            }
            .listStyle(.plain)
            .frame(width: 200, height:210, alignment: .center)
            .padding(.bottom, 50)
            Text("Quedan \(siguientesTurnos.turns.count) turnos por servir")
                .font(.system(size: 15))
                .foregroundStyle(Color(red:102/255, green: 102/255, blue: 102/255))
            Spacer()
        }
            
    }
        
        
    
}

#Preview {
    AdminTurnosView(ventanillaNum: .constant(0), atendiendoAhora: 1)
}

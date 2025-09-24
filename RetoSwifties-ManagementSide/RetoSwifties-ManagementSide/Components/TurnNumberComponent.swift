//
//  TurnNumberComponent.swift
//  RetoSwifties
//
//  Created by Alumno on 27/08/25.
//

import SwiftUI

struct TurnNumberComponent: View {
    @Binding public var numeroTurno: Int
    @State public var size: Float = 190
    @State public var fontSize: Float = 60
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color(red: 1/255, green: 104/255, blue: 138/255),lineWidth: 7)
                .frame(width: CGFloat(size))
                .foregroundStyle(Color.white)
                
            Text(String(numeroTurno))
                .font(.system(size: CGFloat(fontSize), weight: .bold))
                .foregroundStyle(Color(red: 1/255, green: 104/255, blue: 138/255))
        }
    }
}

#Preview {
    TurnNumberComponent(numeroTurno: .constant(0))
}

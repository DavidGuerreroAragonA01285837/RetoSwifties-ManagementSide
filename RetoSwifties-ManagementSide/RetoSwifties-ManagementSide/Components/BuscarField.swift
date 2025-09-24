//
//  BuscarField.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 19/09/25.
//

import SwiftUI

struct BuscarField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
            TextField("Buscar empleado", text: $text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 10)
        .frame(height: 54)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    // Creamos un state local solo para el preview
    struct PreviewWrapper: View {
        @State private var searchText: String = ""

        var body: some View {
            BuscarField(text: $searchText)
                .padding()
        }
    }
    return PreviewWrapper()
}


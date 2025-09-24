import SwiftUI

struct Ajustes: View {
    @State var mensajeRol: String = ""
    @State var estaDisponible: Bool = false
    @State var nombre: String = ""
    @State private var darkMode = false
    
    var body: some View {
        VStack {
            Image(systemName: "person").resizable().scaledToFit().frame(width: 200)
            Text(" \(nombre)")
                .font(.title)
            Divider()
            Text(" \(mensajeRol)")
                .font(.title)
            Divider()

            Text(estaDisponible ? "Activo" : "Inactivo")
                .font(.title)

            
            if estaDisponible {
                Image(systemName: "checkmark.seal.fill")
                    .resizable().scaledToFit().frame(width: 100)
                
                    .foregroundColor(.green)
            }
            else {
                Image(systemName: "xmark.circle.fill")
                    .resizable().scaledToFit().frame(width: 100)
                    .foregroundColor(.red)
            }
        }            .padding(200)
        
        HStack(spacing: 20) {
            Button(action: {
                print("Cerrar Sesión")
            }) {
                Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .font(.title2)
            .padding()
            .foregroundStyle(.white)
            .background(Color.red)
            .cornerRadius(12)
            
            Button(action: {
                darkMode.toggle()   // cambia entre oscuro y claro
            }) {
                Label(darkMode ? "Light Mode" : "Dark Mode", systemImage: darkMode ? "sun.max.fill" : "moon.fill")
                    .frame(maxWidth: .infinity)
            }
            .font(.title2)
            .padding()
            .foregroundStyle(.white)
            .background(darkMode ? Color.orange : Color.black)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Ajustes()
}


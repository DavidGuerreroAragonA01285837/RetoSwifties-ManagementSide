import SwiftUI

struct Ajustes: View {
    let idEmpleado: Int                  // recibimos solo el ID desde login
    @StateObject private var service = EmpleadoService()
    @State private var darkMode = false

    var body: some View {
        VStack(spacing: 40) {
            if service.isLoading {
                ProgressView("Cargando empleado...")
            } else if let empleado = service.empleado {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                VStack(spacing: 10) {
                    Divider().frame(maxWidth: .infinity).background(Color.gray)
                    Text("Id Empleado: \(empleado.idEmpleado)")
                        .font(.largeTitle)
                    Divider().frame(maxWidth: .infinity).background(Color.gray)
                    Text("Nombre: \(empleado.nombre)")
                        .font(.title)
                    Divider().frame(maxWidth: .infinity).background(Color.gray)
                    Text("Rol: \(empleado.rol)")
                        .font(.title)
                    Divider().frame(maxWidth: .infinity).background(Color.gray)
                    Text(empleado.isDisponible ? "Activo" : "Inactivo")
                        .font(.title)
                    
                    Image(systemName: empleado.isDisponible ? "checkmark.seal.fill" : "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120)
                        .foregroundColor(empleado.isDisponible ? .green : .red)
                }
                .padding()
                .background(Color.orange.opacity(0.8))
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding(.horizontal, -20)
                
                HStack(spacing: 50) {
                    Button(action: { print("Cerrar Sesión") }) {
                        Label("Cerrar Sesión", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity)
                    }
                    .font(.title2)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.red)
                    .cornerRadius(12)

                    Button(action: { darkMode.toggle() }) {
                        Label(darkMode ? "Light Mode" : "Dark Mode",
                              systemImage: darkMode ? "sun.max.fill" : "moon.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .font(.title2)
                    .padding()
                    .foregroundStyle(.white)
                    .background(darkMode ? Color.orange : Color.black)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            } else if let error = service.errorMessage {
                Text("Error: \(error)").foregroundColor(.red)
            } else {
                Text("Empleado no encontrado")
            }
        }
        .padding()
        .preferredColorScheme(darkMode ? .dark : .light)
        .onAppear {
            service.fetchEmpleado(by: idEmpleado)
        }
    }
}
#Preview {
    Ajustes(idEmpleado: 1) // ejemplo con ID ficticio
}

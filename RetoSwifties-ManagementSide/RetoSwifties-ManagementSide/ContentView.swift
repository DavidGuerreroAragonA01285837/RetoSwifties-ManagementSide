//
//  ContentView.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 17/09/25.
//

import SwiftUI


struct ContentView: View {
    @State private var isLoggedInAdmin = false
    @State private var isLoggedInEmpleado = false
    @State private var usuario: String = ""
    @State private var contrasena: String = ""
    @State private var mensaje: String = ""
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color(red: 0.0039, green: 0.4078, blue: 0.5411))
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .frame(maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.top)
                
                VStack(spacing: 20) {
                    // Logo centrado sobre el fondo azul
                    Image("novaclinica")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 5)
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    // Campos de login
                    Text("Iniciar Sesión")
                        .font(.system(size: 60))
                        .bold()
                    
                    TextField("Usuario", text: $usuario)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: 400)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $contrasena)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(maxWidth: 400)
                    
                    Button("Ingresar") {
                        loginAPI(username: usuario, password: contrasena) { success, rol in
                            DispatchQueue.main.async {
                                if success, let rol = rol {
                                    if rol.lowercased() == "administrador" {
                                        isLoggedInAdmin = true
                                    } else if rol.lowercased() == "empleado" {
                                        isLoggedInEmpleado = true
                                    }
                                } else {
                                    mensaje = "Usuario o contraseña incorrectos"
                                }
                            }
                        }
                    }
                    .font(.title)
                    .bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color(red: 1/255, green: 104/255, blue: 138/255))
                    .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                    .cornerRadius(8)
                    
                    if !mensaje.isEmpty {
                        Text(mensaje)
                            .foregroundColor(.red)
                            .bold()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $isLoggedInAdmin) {
                HomeAdminView()
            }
            .navigationDestination(isPresented: $isLoggedInEmpleado) {
                HomeEmpleadoView()
            }
        }
    }
}



struct HomeAdminView: View {
    var body: some View {
        VStack {
            Text("Bienvenido Admin")
                .font(.largeTitle)
                .bold()
                .padding()
            Text("Has iniciado sesión correctamente como administrador.")
        }
    }
}

struct HomeEmpleadoView: View {
    var body: some View {
        VStack {
            Text("Bienvenido Empleado")
                .font(.largeTitle)
                .bold()
                .padding()
            Text("Has iniciado sesión correctamente como empleado.")
        }
    }
}



#Preview {
    ContentView()
}

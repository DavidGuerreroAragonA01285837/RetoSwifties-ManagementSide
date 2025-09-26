//
//  API.swift
//  RetoSwifties-ManagementSide
//
//  Created by Elian Genc on 9/25/25.
//

import Foundation

func loginAPI(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
    let userTrimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
    let passTrimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard let url = URL(string: "https://swifties.tc2007b.tec.mx:10206/login") else {
        print("URL inválida")
        completion(false, nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body: [String: String] = ["username": userTrimmed, "password": passTrimmed]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error en la llamada:", error.localizedDescription)
            completion(false, nil)
            return
        }
        
        guard let data = data else {
            print("No se recibieron datos")
            completion(false, nil)
            return
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("Respuesta API:", responseString)
        }
        
        do {
            let result = try JSONDecoder().decode(LoginResponse.self, from: data)
            print("Rol del usuario:", result.rol)
            completion(result.login, result.rol)
        } catch {
            print("Error al decodificar JSON:", error)
            completion(false, nil)
        }
    }.resume()
}

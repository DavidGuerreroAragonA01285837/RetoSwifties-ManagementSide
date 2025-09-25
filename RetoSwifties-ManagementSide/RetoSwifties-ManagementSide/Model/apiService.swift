//
//  apiService.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation

class EmpleadoService: NSObject, URLSessionDelegate {
    
    static let shared = EmpleadoService()
    
    // Función que ignora certificados
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
    
    func fetchEmpleadosAgrupados(completion: @escaping ([Empleado]) -> Void) {
            fetchEmpleados { responses in
                // Agrupar por nombre
                var agrupados: [String: [Int]] = [:]
                for r in responses {
                    agrupados[r.nombre, default: []].append(r.total_atendidos)
                }

                let empleados = agrupados.map { Empleado(nombre: $0.key, semanas: $0.value) }
                DispatchQueue.main.async {
                    completion(empleados)
                }
            }
        }
    func fetchEmpleados(completion: @escaping ([Empleado]) -> Void) {
        guard let url = URL(string: "https://10.14.255.40:10202/empleados/obtener") else {
            print("❌ URL inválida")
            return
        }
        
        // Configurar sesión con el delegate que ignora SSL
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error en la llamada: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("❌ Respuesta inválida del servidor")
                return
            }
            
            guard let data = data else {
                print("❌ No se recibieron datos")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responses = try decoder.decode([EmpleadoResponse].self, from: data)
                let empleados = responses.map { Empleado(from: $0) }
                
                DispatchQueue.main.async {
                    completion(empleados)
                }
            } catch {
                print("❌ Error al decodificar JSON: \(error)")
            }
        }
        task.resume()
    }
}

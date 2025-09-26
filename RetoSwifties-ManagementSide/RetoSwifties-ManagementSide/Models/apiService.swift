//
//  apiService.swift
//  RetoSwifties-ManagementSide
//
//  Created by Alumno on 24/09/25.
//

import Foundation

class EmpleadoServiceD: NSObject, URLSessionDelegate {
    
    static let shared = EmpleadoServiceD()
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
    
    func fetchEmpleadosAgrupados(completion: @escaping ([EmpleadoD]) -> Void) {
            fetchEmpleados { responses in
                // Agrupar por nombre
                var agrupados: [String: [Int]] = [:]
                for r in responses {
                    agrupados[r.nombre, default: []].append(r.total_atendidos)
                }

                let empleados = agrupados.map { EmpleadoD(nombre: $0.key, semanas: $0.value) }
                DispatchQueue.main.async {
                    completion(empleados)
                }
            }
        }
    func fetchEmpleados(completion: @escaping ([EmpleadoD]) -> Void) {
        guard let url = URL(string: "https://10.14.255.40:10206/empleados/obtener") else {
            print("URL inválida")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error en la llamada: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Respuesta inválida del servidor")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responses = try decoder.decode([EmpleadoResponse].self, from: data)
                let empleados = responses.map { EmpleadoD(from: $0) }
                
                DispatchQueue.main.async {
                    completion(empleados)
                }
            } catch {
                print("Error al decodificar JSON: \(error)")
            }
        }
        task.resume()
    }
}

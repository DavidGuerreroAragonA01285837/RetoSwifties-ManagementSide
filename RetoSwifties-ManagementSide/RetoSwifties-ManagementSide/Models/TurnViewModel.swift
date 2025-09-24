//
//  TurnosModelJSON.swift
//  RetoSwifties-ManagementSide
//
//  Created by David on 23/09/25.
//

import Foundation
import Combine

// Custom delegate that ignores SSL validation (⚠️ only for testing!)
class UnsafeSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

class TurnViewModel: ObservableObject {
    @Published var turns: [Turn] = []

    // Fetch turns
    func fetchTurns(completion: (() -> Void)? = nil) {
        guard let url = URL(string: "https://10.14.255.40:10206/turnos/obtener") else { return }

        let session = URLSession(configuration: .default, delegate: UnsafeSessionDelegate(), delegateQueue: nil)

        session.dataTask(with: url) { data, response, error in
            defer { completion?() } // call completion at the end

            if let error = error {
                print("Fetch error:", error)
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode([Turn].self, from: data)
                DispatchQueue.main.async {
                    self.turns = decoded
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

    // Mark turn as served (PUT)
    func markTurnAsServed(serviceID: Int) {
        guard let url = URL(string: "https://10.14.255.40:10206/turnos/finalizar") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["serviceID": serviceID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let session = URLSession(configuration: .default, delegate: UnsafeSessionDelegate(), delegateQueue: nil)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("PUT error:", error)
                return
            }

            if let http = response as? HTTPURLResponse {
                print("PUT status code:", http.statusCode)
            }

            // After finishing a turn, automatically fetch new turns
            self.fetchTurns()
        }.resume()
    }
}


/*
 
 //
 //  TurnosModelJSON.swift
 //  RetoSwifties-ManagementSide
 //
 //  Created by David on 23/09/25.
 //

 import Foundation
 import Combine

 class TurnViewModel: ObservableObject {
     @Published var turns: [Turn] = []  // Array that will store API data

     func fetchTurns() {
         guard let url = URL(string: "https://10.14.255.40:10206/turnos/obtener") else { return }

         URLSession.shared.dataTask(with: url) { data, response, error in
             if let error = error {
                 print("Error: \(error)")
                 return
             }

             if let response = response as? HTTPURLResponse {
                 print("Status code:", response.statusCode)
             }

             if let data = data {
                 // Print raw JSON for debugging (does not affect decoding)
                 if let jsonString = String(data: data, encoding: .utf8) {
                     print("Raw response:\n\(jsonString)")
                 }

                 // Decode as usual
                 do {
                     let decoded = try JSONDecoder().decode([Turn].self, from: data)
                     DispatchQueue.main.async {
                         self.turns = decoded
                     }
                 } catch {
                     print("Decoding error:", error)
                 }
             }
         }.resume()
     }

     
 }



 adapt that into what it needs to be
 
 */

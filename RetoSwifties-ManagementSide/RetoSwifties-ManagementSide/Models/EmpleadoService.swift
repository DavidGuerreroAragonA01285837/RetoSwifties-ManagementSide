import Foundation
import Combine

class EmpleadoService: ObservableObject {
    @Published var empleado: EmpleadoAPI?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchEmpleado(by idEmpleado: Int) {
        guard let url = URL(string: "https://swifties.tc2007b.tec.mx:10206/empleado?idEmpleado=\(idEmpleado)") else {
            self.errorMessage = "URL inválida"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "Datos vacíos"
                    return
                }

                do {
                    // el API devuelve un arreglo de un solo empleado
                    let empleados = try JSONDecoder().decode([EmpleadoAPI].self, from: data)
                    self.empleado = empleados.first
                } catch {
                    self.errorMessage = "Error al decodificar: \(error)"
                }
            }
        }.resume()
    }
}

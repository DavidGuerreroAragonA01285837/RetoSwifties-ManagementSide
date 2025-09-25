import SwiftUI
import Charts

struct ContentView: View {
    @State var empleado: Empleado
    
    // Aquí inventamos una lista de empleados para pruebas
    let listaEmpleados: [Empleado]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Título
                TextoDashboard(empleado: $empleado,empleados:listaEmpleados)
                
                // Gráfica de barras
                GraficaBarra(empleado: $empleado)
                
                // Métricas
                Metricas(empleado: $empleado)
                
                // Gráfico circular
                GraficaPie(empleados: listaEmpleados, empleado: $empleado)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    // Creamos datos de prueba usando EmpleadoResponse
    let response1 = EmpleadoResponse(nombre: "Emilio", total_atendidos: 20, turnDate: "2025-09-23")
    let response2 = EmpleadoResponse(nombre: "David", total_atendidos: 15, turnDate: "2025-09-23")
    let response3 = EmpleadoResponse(nombre: "Rodrigo", total_atendidos: 10, turnDate: "2025-09-23")
    
    let empleados = [Empleado(from: response1), Empleado(from: response2), Empleado(from: response3)]
    
    return ContentView(
        empleado: empleados[0],
        listaEmpleados: empleados
    )
}


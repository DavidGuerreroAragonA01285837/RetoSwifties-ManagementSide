import SwiftUI
import Charts

struct ContentView: View {
    @State var empleado: Empleado
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Título
                TextoDashboard(empleado:$empleado)
                
                GraficaBarra(empleado: $empleado)   // <- solo copia
                Metricas(empleado: $empleado) // <- copia

                GraficaPie(empleados:listaEmpleados,empleado:$empleado)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(empleado: Empleado(
        id: 1,
        nombre: "Emilio",
        apellido: "Barragan",
        semanas: [10,13,20,18,21,9,6]
      ))
}

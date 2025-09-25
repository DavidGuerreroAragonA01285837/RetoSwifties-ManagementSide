import SwiftUI
import Charts

struct DashboardView: View {
    @State public var empleado: Empleado = Empleado(nombre: "Cargando...", semanas: [0,1,2,3])
    @State public var listaEmpleados: [Empleado] = []
    
    var body: some View {
        //ScrollView {
            VStack(spacing: 20) {
                
                if !listaEmpleados.isEmpty {
                    // Título y selección de empleado
                    TextoDashboard(empleado: $empleado, empleados: listaEmpleados)
                    
                    // Gráfica de barras
                    GraficaBarra(empleado: $empleado)
                            // Métricas
                    Metricas(empleado: $empleado)
                        .padding(.top, -20)
                    
                    // Gráfico circular
                    GraficaPie(empleados: listaEmpleados, empleado: $empleado)
                } else {
                    Text("Cargando empleados...")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.sRGB, red: 242/255, green: 242/255, blue: 242/255))
                    .shadow(color: Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9),
                            radius: 6, x: 0, y: 3)
            )
            .padding()
            .onAppear {
                EmpleadoService.shared.fetchEmpleadosAgrupados { empleados in
                    self.listaEmpleados = empleados
                    if let primero = empleados.first {
                        self.empleado = primero
                    }
                }
            }
        }
   // }
}

#Preview {
    DashboardView()
}

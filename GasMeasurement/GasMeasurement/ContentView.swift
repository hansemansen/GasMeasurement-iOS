import Firebase
import SwiftUI

struct ContentView: View {
    @Environment(MeasurementController.self) var measurementController
    @State private var activeSheet: ActiveSheet?
    @Environment(AuthUserController.self) var authController
    @Environment(UserController.self) var userController
    @State private var selectedImage: UIImage?
    @AppStorage("username") var brugernick: String = ""
    @State private var flyIn = false
    @State private var rotate = false

    var body: some View {
        VStack {
            if let selectedImage = userController.image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .offset(x: flyIn ? 0 : -UIScreen.main.bounds.width)  // Start udenfor skærmen til venstre
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(.spring(response: 0.8, dampingFraction: 0.2))
                                } else {
                Text("Intet billede valgt")
            }

            if brugernick.isEmpty {
                Text("Velkommen, gæst!")
            } else {
                Text("Velkommen tilbage, \(brugernick)!")
            }

            Button("Add Measurement") {
                activeSheet = .addMeasurement
            }
            .buttonStyle(.borderedProminent)

            Button("Add Preferences") {
                activeSheet = .addPreferences
            }
            .tint(Color.green)
            .buttonStyle(.borderedProminent)

            List {
                ForEach(
                    measurementController.measurements
                        .filter { $0.id != nil }
                        .sorted(by: { $0.dato < $1.dato })
                ) { measurement in
                    HStack {
                        Text(
                            measurement.dato.formatted(
                                date: .abbreviated, time: .shortened))
                        Spacer()
                        Text("\(measurement.measurement)")
                    }
                }
                .onDelete { indexSet in
                    measurementController.deleteMeasurement(at: indexSet)
                }
            }
            .onAppear {
                measurementController.getMeasurements()
                flyIn = true
                rotate.toggle()
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addMeasurement:
                    AddMeasurementView(
                        isPresented: Binding(
                            get: { activeSheet == .addMeasurement },
                            set: { if !$0 { activeSheet = nil } }
                        )
                    )
                    .presentationDetents([.medium])

                case .addPreferences:
                    AddPreferencesView(
                        isPresented: Binding(
                            get: { activeSheet == .addPreferences },
                            set: { if !$0 { activeSheet = nil } }
                        )
                    )
                    .presentationDetents([.large])
                }
            }

            Spacer()

            Button("Log ud") {
                authController.logout()
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding()
        }
    }
}
#Preview {
    ContentView()
        .environment(MeasurementController())
        .environment(AuthUserController())
        .environment(UserController())
}

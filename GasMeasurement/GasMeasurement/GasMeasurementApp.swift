import SwiftUI
import FirebaseCore

@main
struct GasMeasurementApp: App {
    @State private var auth: AuthUserController

    init() {
        FirebaseApp.configure()
        _auth = State(wrappedValue: AuthUserController())
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if auth.user != nil {
                    ContentView()
                        .environment(MeasurementController())
                        .environment(auth)
                        .environment(UserController())
                } else {
                    LoginView()
                        .environment(auth)
                }
            }
        }
    }
}

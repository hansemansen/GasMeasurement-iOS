import Foundation
import FirebaseAuth

@Observable
class AuthUserController {
    var user: User?
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    let firebaseService = MeasurementService()

    init() {
        listenToAuthState()
    }

    func listenToAuthState() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            print("🔄 Auth state changed. User er nu: \(String(describing: user))")
            self?.user = user
        }
    }

    func logout() {
        do {
            try firebaseService.logout()
            print("✅ Brugeren blev logget ud!")
        } catch {
            print("❌ Logout fejl: \(error.localizedDescription)")
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

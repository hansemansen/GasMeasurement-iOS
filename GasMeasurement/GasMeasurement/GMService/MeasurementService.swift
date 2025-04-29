import FirebaseAuth
import FirebaseFirestore
import Foundation

class MeasurementService {
    private let dbRef = Firestore.firestore()

    func fetchMeasurements(completionHandler: @escaping ([Measurement]) -> Void)
    {
        dbRef.collection("measurements").addSnapshotListener {
            querysnapshot, error in
            guard let snapshot = querysnapshot else { return }

            let measurements = snapshot.documents.compactMap {
                try? $0.data(as: Measurement.self)
            }

            completionHandler(measurements)
        }
    }

    func addMeasurement(
        _ measurement: Measurement, completion: @escaping (Error?) -> Void
    ) {
        do {
            try dbRef.collection("measurements").addDocument(from: measurement)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteMeasurement(withId id: String) {
        dbRef.collection("measurements").document(id).delete()
    }
    
    
    func login(email: String, password: String) async throws -> User? {
        let result = try await Auth.auth().signIn(
            withEmail: email,
            password: password)
        print(result.user)
        return result.user
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
}

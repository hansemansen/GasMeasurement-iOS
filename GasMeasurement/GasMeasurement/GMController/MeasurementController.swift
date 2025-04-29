import SwiftUI
import Firebase

@Observable
class MeasurementController {
    private let service = MeasurementService()

    var measurements: [Measurement] = []

    func getMeasurements() {
        service.fetchMeasurements { [weak self] fetched in
            self?.measurements = fetched
        }
    }

    func deleteMeasurement(at offsets: IndexSet) {
        let sorted = measurements.sorted { $0.dato < $1.dato }
        for index in offsets {
            if let id = sorted[index].id {
                service.deleteMeasurement(withId: id)
            }
        }
    }

    func addMeasurement(dato: Date, measurement: Int, completion: @escaping (Error?) -> Void) {
        let new = Measurement(dato: dato, measurement: measurement)
        service.addMeasurement(new, completion: completion)
    }
    
 
}

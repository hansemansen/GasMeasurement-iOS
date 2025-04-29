//
//  Measurement.swift
//  GasMeasurement
//
//  Created by dmu mac 26 on 28/03/2025.
//

import FirebaseFirestore
import Foundation

struct Measurement: Identifiable, Codable {
    
    let dato: Date
    let measurement: Int
    @DocumentID var id: String?
    
}

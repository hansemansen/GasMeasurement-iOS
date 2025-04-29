//
//  Untitled.swift
//  GasMeasurement
//
//  Created by dmu mac 26 on 04/04/2025.
//

enum ActiveSheet: Identifiable {
    case addMeasurement
    case addPreferences

    var id: Int {
        hashValue
    }
}

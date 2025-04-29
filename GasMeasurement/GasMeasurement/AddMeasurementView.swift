//
//  AddMeasurementView.swift
//  GasMeasurement
//
//  Created by dmu mac 26 on 28/03/2025.
//

import FirebaseFirestore
import SwiftUI

struct AddMeasurementView: View {
    @Environment(MeasurementController.self) var measurementController
    @Binding var isPresented: Bool

    @State private var dato: Date = Date()
    @State private var measurement: Int = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Indtast measurement")
                    .font(.system(size: 40))
                    .bold()
                    .padding(.bottom, 5)
                Form {
                    DatePicker("Please enter a date", selection: $dato)
                    TextField(
                        "Indtast måling", value: $measurement,
                        formatter: NumberFormatter()
                    )
                    .keyboardType(.numberPad)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        measurementController.addMeasurement(dato: dato, measurement: measurement) { error in
                            if let error = error {
                                print("Fejl: \(error.localizedDescription)")
                            } else {
                                isPresented = false
                            }
                        }
                    }
                }
            }
        }
    }
}

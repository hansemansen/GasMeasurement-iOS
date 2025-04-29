import FirebaseFirestore
import PhotosUI
import SwiftUI

struct AddPreferencesView: View {
    @Environment(UserController.self) var userController
    @Binding var isPresented: Bool
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @AppStorage("username") var brugernick: String = ""
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Indtast brugernavn")
                    .font(.system(size: 40))
                    .bold()

                TextField("Skriv dit brugernavn", text: $brugernick)
                    .textFieldStyle(.roundedBorder)
                    .padding(.trailing)

                PhotosPicker(
                    "Vælg billede", selection: $selectedItem, matching: .images
                )
                .buttonStyle(.borderedProminent)
                .onChange(of: selectedItem) { oldValue, newValue in
                    guard let newValue else { return }
                    Task {
                        if let data = try? await newValue.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            userController.saveImage(uiImage)
                            selectedImage = uiImage
                        }
                    }
                }

                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200, maxHeight: 200)
                        .cornerRadius(10)
                        .padding()
                        .phaseAnimator([false, true]) { wwdc24, chromaRotate in
                            wwdc24
                                .hueRotation(.degrees(chromaRotate ? 420 : 0))
                        } animation: { chromaRotate in
                            .easeInOut(duration: 2)
                        }
                }

                Spacer()

                Button("Gem og luk") {
                    userController.setBrugernick(brugernick)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding()
            }
            .padding()
            .navigationTitle("Brugerindstillinger")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

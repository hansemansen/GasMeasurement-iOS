import Foundation
import SwiftUI

@Observable
class UserController {
    
    static let fileURL = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask
    ).first!.appendingPathComponent("savedImage")
    
    
    private var brugernick: String = ""
    var image: UIImage?

    
    func getBrugernick() -> String {
        return brugernick
    }

    
    func setBrugernick(_ nick: String) {
        brugernick = nick
    }

    init() {
        loadImage()
    }

    // Gem billede
    func saveImage(_ image: UIImage) {
        if let data = image.pngData() {
            do {
                try data.write(to: UserController.fileURL)
                self.image = image
            } catch {
                print("Fejl ved lagring af billedet")
            }
        }
    }

    // Læs billede 
    func loadImage() {
        if let data = try? Data(contentsOf: UserController.fileURL),
            let loadedImage = UIImage(data: data)
        {
            self.image = loadedImage
        }
    }
}

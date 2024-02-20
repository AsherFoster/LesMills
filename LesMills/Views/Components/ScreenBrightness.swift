import Foundation
import SwiftUI

struct ScreenBrightness: View {
    let desieredBrightness: CGFloat = 1.0
    @State private var previousBrightness: CGFloat = 1.0
    
    var body: some View {
        Group {}
            .onAppear {
                previousBrightness = UIScreen.main.brightness
                UIScreen.main.brightness = desieredBrightness
            }
            .onDisappear {
                UIScreen.main.brightness = previousBrightness
            }
    }
}

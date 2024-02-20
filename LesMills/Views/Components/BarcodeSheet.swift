import SwiftUI

struct BarcodeSheet: View {
    public var profile: UserProfile
    
    var body: some View {
        ScreenBrightness()
        Barcode(message: String(profile.lesMillsID))
            .presentationDetents([.height(290)])
            .presentationDragIndicator(.visible)
    }
}

#Preview {
    BarcodeSheet(profile: .mock())
}

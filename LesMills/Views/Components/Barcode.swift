import SwiftUI
import CoreImage.CIFilterBuiltins

struct Barcode: View {
    public var message: String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
            
            Text(message)
        }
    }
    
    var image: Image {
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = Data(message.utf8)
        
        guard let ciImage = filter.outputImage else {
            return Image(systemName: "exclamationmark.circle")
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return Image(systemName: "exclamationmark.circle")
        }

        
        return Image(uiImage: UIImage(cgImage: cgImage))
            .interpolation(.none)
    }
}

#Preview {
    Barcode(message: "123")
}

//
//  Barcode.swift
//  LesMills
//
//  Created by Asher Foster on 13/12/23.
//

import SwiftUI
import UIKit
import CoreImage.CIFilterBuiltins
import CoreGraphics
import Metal
import MetalKit

class Renderer: NSObject, MTKViewDelegate, ObservableObject {
    let imageProvider: (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage? // caller delegate function to provide image data
    
    public let device: MTLDevice? = MTLCreateSystemDefaultDevice()
    
    let commandQueue: MTLCommandQueue?
    let renderContext: CIContext? // set the name, cache preferences, and low power settings
    let renderQueue = DispatchSemaphore(value: 3) // Used to wait for a previous render to complete before drawing a new frame
    
    init(imageProvider: @escaping (_ contentScaleFactor: CGFloat, _ headroom: CGFloat) -> CIImage?) {
        self.imageProvider = imageProvider
        self.commandQueue = self.device?.makeCommandQueue()
        if let commandQueue {
            self.renderContext = CIContext(mtlCommandQueue: commandQueue,
                                       options: [.name: "Renderer",
                                                 .cacheIntermediates: true,
                                                 .allowLowPower: true])
        } else {
            self.renderContext = nil
        }
        super.init()
    }
    
    func draw(in view: MTKView) {
        
        guard let commandQueue else { return }

        // wait for previous render to complete
        _ = renderQueue.wait(timeout: DispatchTime.distantFuture)
        
        if let commandBuffer = commandQueue.makeCommandBuffer() {
            
            // when command completed, single the queue to allow rendering next frame
            commandBuffer.addCompletedHandler { (_ commandBuffer)-> Swift.Void in
                self.renderQueue.signal()
            }
            
            if let drawable = view.currentDrawable {
                
                let drawSize = view.drawableSize
                let contentScaleFactor = view.contentScaleFactor
                let destination = CIRenderDestination(width: Int(drawSize.width),
                                                      height: Int(drawSize.height),
                                                      pixelFormat: view.colorPixelFormat,
                                                      commandBuffer: commandBuffer,
                                                      mtlTextureProvider: { () -> MTLTexture in
                    return drawable.texture
                })
                
                // calculate the maximum supported EDR value (headroom)
                var headroom = CGFloat(1.0)
                if #available(iOS 16.0, *) {
                    headroom = view.window?.screen.currentEDRHeadroom ?? 1.0
                }
                
                // Get the CI image to be displayed from the delegate function
                guard var image = self.imageProvider(contentScaleFactor, headroom) else {
                    return
                }

                // Center the image in the view's visible area.
                let iRect = image.extent
                let backBounds = CGRect(x: 0,
                                        y: 0,
                                        width: drawSize.width,
                                        height: drawSize.height)
                let shiftX = round((backBounds.size.width + iRect.origin.x - iRect.size.width) * 0.5)
                let shiftY = round((backBounds.size.height + iRect.origin.y - iRect.size.height) * 0.5)
                image = image.transformed(by: CGAffineTransform(translationX: shiftX, y: shiftY))
                
                // provide a background if the image is transparent
                image = image.composited(over: .gray)
                
                // Start a task that renders to the texture destination.
                guard let renderContext else { return }
                _ = try? renderContext.startTask(toRender: image, from: backBounds,
                                                  to: destination, at: CGPoint.zero)
                
                // show rendered work and commit render task
                commandBuffer.present(drawable)
                commandBuffer.commit()
            }
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Respond to drawable size or orientation changes.
    }
    
}
struct MetalView_SwiftUICompatible: UIViewRepresentable {
    @StateObject var renderer: Renderer
    
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: renderer.device)

        // Suggest to Core Animation, through MetalKit, how often to redraw the view.
        view.preferredFramesPerSecond = 10

        // Allow Core Image to render to the view using the Metal compute pipeline.
        view.framebufferOnly = false
        view.delegate = renderer

        if let layer = view.layer as? CAMetalLayer {
            // Enable EDR with a color space that supports values greater than SDR.
            if #available(iOS 16.0, *) {
                layer.wantsExtendedDynamicRangeContent = true
            }
            layer.colorspace = CGColorSpace(name: CGColorSpace.extendedLinearDisplayP3)
            // Ensure the render view supports pixel values in EDR.
            view.colorPixelFormat = MTLPixelFormat.rgba16Float
        }
        return view
    }
    
    func updateUIView(_ view: MTKView, context: Context) {
        configure(view: view, using: renderer)
    }
    
    private func configure(view: MTKView, using renderer: Renderer) {
        view.delegate = renderer
    }
}
struct HighlightedQRCodeView: View {
    public var image: CIImage
    public var size: CGSize
    
    var body: some View {
        
        // Create a Metal view with its own renderer.
        let renderer = Renderer(imageProvider: { (scaleFactor: CGFloat, headroom: CGFloat) -> CIImage? in
            let qrImage = image.transformed(by: CGAffineTransform(scaleX: 12, y: 12))
            
            // Generate blank fill image with the max RGB color
            let maxRGB = headroom
            guard let EDR_colorSpace = CGColorSpace(name: CGColorSpace.extendedLinearSRGB),
                  let maxFillColor = CIColor(red: maxRGB, green: maxRGB, blue: maxRGB,
                                             colorSpace: EDR_colorSpace) else {
                return nil
            }
            let fillImage = CIImage(color: maxFillColor)
            
            // Use mask filter to create final QR code image
            let maskFilter = CIFilter.blendWithMask()
            maskFilter.maskImage = qrImage
            maskFilter.inputImage = fillImage
            
            // combine highlight layer and QR image
            guard let combinedImage = maskFilter.outputImage else {
                return nil
            }
            return combinedImage
//                .cropped(to: CGRect(x: 0, y: 0,
//                                    width: size.width * scaleFactor,
//                                    height: size.height * scaleFactor))
        })
        
        MetalView_SwiftUICompatible(renderer: renderer)
            .frame(width: size.width, height: size.height)
    }
    
}

struct Barcode: View {
    public var message: String
    
    var body: some View {
        VStack {
            HighlightedQRCodeView(image: ciImage, size: CGSize(width: 300, height: 150))
            
            image
                .resizable()
                .scaledToFit()
            
            Text(message)
        }
    }
    
    var ciImage: CIImage {
        let filter = CIFilter.code128BarcodeGenerator()
        filter.message = Data(message.utf8)
        
        return filter.outputImage!
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

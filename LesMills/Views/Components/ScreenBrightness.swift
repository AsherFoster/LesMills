import Foundation
import SwiftUI
import UIKit

class UIScreenBrightnessViewController: UIViewController {
    let desieredBrightness: CGFloat = 1.0
    private var previousBrightness: CGFloat = 1.0
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        previousBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = desieredBrightness
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        UIScreen.main.brightness = previousBrightness
    }
}

struct ScreenBrightness: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIScreenBrightnessViewController, context: Context) {
//        return uiViewController.
    }
    
    func makeUIViewController(context: Context) -> UIScreenBrightnessViewController {
        return UIScreenBrightnessViewController()
    }
}

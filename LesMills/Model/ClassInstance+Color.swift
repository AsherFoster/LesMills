//
//  ClassInstance+Color.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Foundation
import SwiftUI

extension ClassSession {
    private static let defaultColor = Color.red
    var color: Color {
        guard let rgb = Int(cmsColour.dropFirst(1), radix: 16) else {
            return ClassSession.defaultColor
        }
        
        return Color(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
}

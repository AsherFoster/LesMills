//
//  ShowBarcode.swift
//  LesMills
//
//  Created by Asher Foster on 13/12/23.
//

import SwiftUI

struct ShowBarcode: View {
    public var profile: UserContactDetails
    @State var sheetShown: Bool = false
    
    var body: some View {
        Button { sheetShown.toggle() } label: {
            Label("Show barcode", systemImage: "barcode")
                .frame(maxWidth: .infinity)
        }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .sheet(isPresented: $sheetShown) {
//                ScreenBrightness()
                Barcode(message: String(profile.lesMillsID))
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
    }
}

#Preview {
    ShowBarcode(profile: .mock())
}

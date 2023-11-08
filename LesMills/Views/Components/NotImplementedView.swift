//
//  NotImplementedView.swift
//  LesMills
//
//  Created by Asher Foster on 5/10/23.
//

import SwiftUI

struct NotImplementedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
            Text("Not implemented yet.")
        }
    }
}

#Preview {
    NotImplementedView()
}

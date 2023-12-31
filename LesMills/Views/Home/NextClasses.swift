//
//  NextClasses.swift
//  LesMills
//
//  Created by Asher Foster on 10/12/23.
//

import SwiftUI

struct NextClasses: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Next classes")
                    .font(.title2)
                Text(try! AttributedString(markdown: "At **Taranaki Street**"))
                    .font(.subheadline)
            }
            Spacer()
            NavigationLink {
                ClassesView()
            } label: {
                HStack {
                    Text("More")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.bold())
            }
        }
    }
}

#Preview {
    NextClasses(viewModel: .init())
}

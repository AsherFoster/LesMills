//
//  HomeView.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

struct HomeView: View {
    var classesToday: [ClassInstance]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Today")
                    .font(.title2)
                Group{}
                Button("Show barcode", systemImage: "barcode") {}
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Next classes")
                            .font(.title2)
                        HStack {
                            Text("At")
                            Text("Tarankai Street").bold()
                        }
                        
                        .font(.body)
                        
                    }
                    Spacer()
                    Button() {} label: {
                        HStack {
                            Text("More")
                            Image(systemName: "chevron.right")
                        }
                        .font(.subheadline.bold())
                    }
                }
                List (classesToday) {
                    ClassRow(classInstance: $0)
                }.listStyle(.plain)
                
                Spacer()
            }
            .navigationTitle("Kia ora, Asher")
        }
    }
}

#Preview {
    HomeView(classesToday: [.mock])
        .preferredColorScheme(.dark)
}

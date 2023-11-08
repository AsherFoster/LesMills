//
//  ClassesView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct ClassesViewHeader: View {    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    HStack {
                        Text("Today")
                        Image(systemName: "chevron.right")
                    }
                }
                Spacer()
                
                Button("Previous Day", systemImage: "chevron.left") {}
                    .labelStyle(.iconOnly)
                    .disabled(true)
                Button("Next Day", systemImage: "chevron.right") {}
                    .labelStyle(.iconOnly)
            }
            .padding(.bottom)
            
            HStack {
                Button(action: {}) {
                    HStack {
                        Text("2 clubs")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                Button(action: {}) {
                    HStack {
                        Text("Instructor")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                Button(action: {}) {
                    HStack {
                        Text("Class")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
            }
        }
        .padding(.all)
    }
}

struct ClassesView: View {
    var body: some View {
        NavigationStack {
            ClassesViewHeader()
            Section {
                List([ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock()]) {
                    ClassRow(classInstance: $0)
                }
                .listStyle(.plain)
            }
//            .toolbar {
//                ToolbarItemGroup {
//                    Button("Previous Day", systemImage: "chevron.left") {}
//                    Button("Next Day", systemImage: "chevron.right") {}
//                }
//            }
            .navigationTitle("Classes")
        }
    }
}

#Preview {
    ClassesView()
}

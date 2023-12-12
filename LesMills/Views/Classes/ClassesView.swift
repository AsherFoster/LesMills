//
//  ClassesView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct FilterChip<Content: View>: View {
    public var label: String
    public var active: Bool
    public var selectValue: () -> Content
    
    @State private var filterOpen = false
    
    @ViewBuilder
    var body: some View {
        if active {
            base
                .buttonStyle(.borderedProminent)
        } else {
            base
                .buttonStyle(.bordered)
        }
    }
    
    var base: some View {
        Button {
            filterOpen.toggle()
        } label: {
            HStack {
                Text(label)
                Image(systemName: "chevron.down")
            }
        }
        .controlSize(.small)
        .sheet(isPresented: $filterOpen) {
            selectValue()
                .presentationDragIndicator(.visible)
        }
    }
}


struct ClassesViewHeader: View {
    @ObservedObject var viewModel: ClassesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    HStack {
                        if let day = viewModel.viewingDate?.day {
                            Text(String(day))
                        } else {
                            Text("idk")
                        }
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
            
            ClassesViewFilters(viewModel: viewModel)
        }
        .padding(.all)
        
    }
}

struct ClassesView: View {
    @StateObject private var viewModel: ClassesViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ClassesViewHeader(viewModel: viewModel)
            Section {
                classes
            }
            .toolbar {
                ToolbarItemGroup {
                    Button("Previous Day", systemImage: "chevron.left") {}
                    Button("Next Day", systemImage: "chevron.right") {}
                }
            }
            .navigationTitle("Classes")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    @ViewBuilder
    var classes: some View {
        if let classes = viewModel.classes {
            List(classes) {
                ClassRow(classInstance: $0)
            }
            .listStyle(.plain)
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ClassesView()
}

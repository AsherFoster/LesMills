//
//  ClassesViewFilters.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import SwiftUI

struct ClassesViewFilters: View {
    @ObservedObject var viewModel: ClassesViewModel
    
    var body: some View {
        HStack {
            FilterChip(label: "Clubs", active: !viewModel.selectedClubs.isEmpty) {
                MultiSelectList(
                    options: viewModel.allClubs,
                    selection: $viewModel.selectedClubs
                ) { Text($0.nodeName) }
            }
            FilterChip(label: "Instructor", active: !viewModel.selectedInstructors.isEmpty) {
                MultiSelectList(
                    options: viewModel.allInstructors,
                    selection: $viewModel.selectedInstructors
                ) { Text($0.name) }
            }
            FilterChip(label: "Class", active: !viewModel.selectedClassTypes.isEmpty) {
                MultiSelectList(
                    options: viewModel.allClassTypes,
                    selection: $viewModel.selectedClassTypes
                ) { Text($0.name) }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ClassesViewFilters(viewModel: .init())
}

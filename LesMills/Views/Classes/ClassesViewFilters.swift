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
                List {
                    Section {
                        ForEach(viewModel.allClubs.filter {
                            $0.id == viewModel.profile!.homeClubGuid
                        }) { club in
                            MultiSelectItem(option: club, selection: selectedClubs) {
                                Text(club.nodeName)
                            }
                        }
                    }
                    Section {
                        ForEach(viewModel.allClubs.filter {
                            $0.id != viewModel.profile!.homeClubGuid
                        }) { club in
                            MultiSelectItem(option: club, selection: selectedClubs) {
                                Text(club.nodeName)
                            }
                        }
                    }
                }
            }
            FilterChip(label: "Instructor", active: !viewModel.selectedInstructors.isEmpty) {
                List {
                    Section(header: Text("Instructors this week")) {
                        ForEach(viewModel.instructorsInTimetable) { instructor in
                            MultiSelectItem(option: instructor, selection: $viewModel.selectedInstructors) {
                                Text(instructor.name)
                            }
                        }
                    }
                    Section(header: Text("Other instructors")) {
                        ForEach(
                            viewModel.allInstructors.filter { !viewModel.instructorsInTimetable.contains($0) }
                        ) { instructor in
                            MultiSelectItem(option: instructor, selection: $viewModel.selectedInstructors) {
                                Text(instructor.name)
                            }
                        }
                    }
                }
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
    
    private var selectedClubs: Binding<Set<DetailedClub>> {
        Binding<Set<DetailedClub>>(
            get: {
                viewModel.selectedClubs
            },
            set: { newValue in
                Task {
                    try await viewModel.setSelectedClubs(newValue)
                }
            }
        )
    }
}

#Preview {
    ClassesViewFilters(viewModel: .mock())
}

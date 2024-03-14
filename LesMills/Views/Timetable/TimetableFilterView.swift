import SwiftUI

struct TimetableFilterView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        HStack {
            FilterChip(label: "Clubs", active: !viewModel.selectedClubs.isEmpty) {
                List {
                    Section {
                        ForEach(viewModel.allClubs.filter {
                            $0.id == viewModel.profile.homeClubGuid
                        }) { club in
                            MultiSelectItem(option: club, selection: selectedClubs) {
                                Text(club.name)
                            }
                        }
                    }
                    Section {
                        ForEach(viewModel.allClubs.filter {
                            $0.id != viewModel.profile.homeClubGuid
                        }) { club in
                            MultiSelectItem(option: club, selection: selectedClubs) {
                                Text(club.name)
                            }
                        }
                    }
                }
            }
            FilterChip(label: "Instructor", active: !viewModel.selectedInstructors.isEmpty) {
                List {
                    Section(header: Text("Instructors this week")) {
                        ForEach(viewModel.instructorsInTimetable, id: \.self) { instructor in
                            MultiSelectItem(option: instructor, selection: $viewModel.selectedInstructors) {
                                Text(instructor)
                            }
                        }
                    }
                    Section(header: Text("Other instructors")) {
                        ForEach(
                            viewModel.allInstructors.filter { !viewModel.instructorsInTimetable.contains($0) },
                            id: \.self
                        ) { instructor in
                            MultiSelectItem(option: instructor, selection: $viewModel.selectedInstructors) {
                                Text(instructor)
                            }
                        }
                    }
                }
            }
            FilterChip(label: "Class", active: !viewModel.selectedClassTypes.isEmpty) {
                MultiSelectList(
                    options: viewModel.allClassTypes,
                    selection: $viewModel.selectedClassTypes
                ) { Text($0.genericName) }
            }
            
            Spacer()
        }
    }
    
    private var selectedClubs: Binding<Set<Club>> {
        Binding<Set<Club>>(
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
    TimetableFilterView(viewModel: .mock())
}

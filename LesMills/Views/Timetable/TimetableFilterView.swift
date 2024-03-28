import SwiftUI

struct TimetableFilterView: View {
    @ObservedObject var viewModel: MainViewModel
    
    private func pluralised(_ count: Int, singular: String, plural: String) -> String {
        if count == 0 {
            return plural.localizedCapitalized
        }
        return count.formatted() + " " + (count == 1 ? singular : plural)
    }
    var body: some View {
        HStack {
            FilterChip(
                label: pluralised(viewModel.selectedClubs.count, singular: "club", plural: "clubs"),
                active: !viewModel.selectedClubs.isEmpty
            ) {
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
            FilterChip(
                label: pluralised(viewModel.selectedInstructors.count, singular: "instructor", plural: "instructors"),
                active: !viewModel.selectedInstructors.isEmpty
            ) {
                List(viewModel.instructorsInTimetable, id: \.self) { instructor in
                    MultiSelectItem(option: instructor, selection: $viewModel.selectedInstructors) {
                        Text(instructor)
                    }
                }
            }
            FilterChip(
                label: pluralised(viewModel.selectedClassTypes.count, singular: "class", plural: "classes"),
                active: !viewModel.selectedClassTypes.isEmpty
            ) {
                MultiSelectList(
                    options: viewModel.allClassTypes,
                    selection: $viewModel.selectedClassTypes
                ) { Text($0.genericName) }
                    .toolbar {
                        Button("Clear") {}
                    }
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

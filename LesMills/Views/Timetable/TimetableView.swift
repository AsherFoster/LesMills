import SwiftUI

struct TimetableView: View {
    @StateObject private var viewModel = ClassesViewModel()
    
    var body: some View {
        NavigationStack {
            header
                .padding(.horizontal)
                .padding(.top)
            Section {
                classes
                Spacer()
            }
                .onAppear {
                    viewModel.loadData()
                }
        }
    }
    
    var header: some View {
        VStack {
            TimetableFilterView(viewModel: viewModel)
            
            if let dates = viewModel.timetableDates {
                ScrollView(.horizontal) {
                    Picker("Date", selection: $viewModel.selectedDate) {
                        ForEach(dates, id: \.self) {
                            Text($0, formatter: CommonDateFormats.dayOfWeek)
                        }
                    }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 16)
                }
            } else {
                // Fake picker with loading indicator
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .background {
                        Rectangle()
                            .fill(.quinary)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                    .padding(.vertical, 16)
            }
        }
    }
    
    @ViewBuilder
    var classes: some View {
        if !viewModel.isLoading, let timetableDates = viewModel.timetableDates {
            // TODO this could potentially be a TabView or something better
            TimetablePageViewController(
                pages: timetableDates.map {
                    sessionList(date: $0)
                },
                currentPage: Binding(
                    get: {
                        timetableDates.firstIndex(of: viewModel.selectedDate)!
                    },
                    set: {
                        viewModel.selectedDate = timetableDates[$0]
                    }
                )
            )
        } else {
            ProgressView()
        }
    }
    
    func sessionList(date: Date) -> some View {
        List(viewModel.filteredSessions(forDate: date)) {
            SessionRow(session: $0)
        }
        .listStyle(.plain)
        .refreshable {
            try! await viewModel.refreshTimetable()
        }
    }
}

#Preview {
    TimetableView()
}

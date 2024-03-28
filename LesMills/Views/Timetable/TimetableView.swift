import SwiftUI

struct TimetableView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        header
            .padding(.horizontal)
            .padding(.top)
        
        if #available(iOS 17.0, *) {
            classes
            .sensoryFeedback(
                .success,
                trigger: viewModel.timetable?.classes
            )
        } else {
            classes
        }
    }
    
    var header: some View {
        VStack {
            TimetableFilterView(viewModel: viewModel)
            
            if let dates = viewModel.timetable?.dates {
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
        TabView(selection: $viewModel.selectedDate) {
            ForEach(viewModel.timetable?.dates ?? [], id: \.self) { date in
                sessionList(date: date)
                    .tabItem {
                        Text(date, formatter: CommonDateFormats.dayOfWeek)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    func sessionList(date: Date) -> some View {
        let unfilteredSessions = viewModel.timetable?.classesForDate(date: date) ?? []
        let sessions = viewModel.filteredSessions(forDate: date)
        if sessions.isEmpty && !unfilteredSessions.isEmpty {
            VStack {
                Text("🫥")
                    .font(.title)
                Text("Nothing's left")
                    .font(.headline)
                Text("Try removing some filters?")
                    .font(.subheadline)
            }
        } else {
            List(sessions) {
                SessionRow(session: $0)
            }
            .listStyle(.plain)
            .refreshable {
                try! await viewModel.refreshTimetable()
            }
        }
    }
}

#Preview {
    TimetableView(viewModel: .mock())
}

#Preview("Nothing's left") {
    let viewModel = MainViewModel.mock()
    viewModel.selectedClassTypes = [viewModel.allClassTypes[0]]
    return TimetableView(viewModel: viewModel)
}

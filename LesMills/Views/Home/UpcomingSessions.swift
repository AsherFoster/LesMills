//
//  ClassesToday.swift
//  LesMills
//
//  Created by Asher Foster on 7/11/23.
//

import SwiftUI

struct UpcomingSessions: View {
    @ObservedObject var viewModel: HomeViewModel

    @ViewBuilder
    var body: some View {
        if viewModel.isLoading {
            VStack(alignment: .center) {
                ProgressView()
                    .padding()
            }
        } else {
            if let sessions = viewModel.bookedSessions, !sessions.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(sessionsByDate, id: \.0) { (date, sessions) in
                        dateHeader(date)
                        ForEach(sessions) { session in
                            BookedSession(session: session)
                        }
                        .navigationDestination(for: ClassSession.self) { session in
                            SessionDetail(session: session)
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                VStack(alignment: .leading) {
                    dateHeader(Date.now)
                    HStack {
                        Spacer()
                        Text("No classes today!")
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }
    
    var sessionsByDate: [(Date, [ClassSession])] {
        let calendar = Calendar.current
        if let bookedSessions = viewModel.bookedSessions {
            return bookedSessions
                .map { calendar.startOfDay(for: $0.startsAt) }
                .deduplicate()
                .map { date in
                    (
                        date,
                        bookedSessions.filter { calendar.isDate($0.startsAt, inSameDayAs: date) }
                    )
                }
        }
        return []
    }
    
    @ViewBuilder
    func dateHeader(_ date: Date) -> some View {
        if Calendar.current.isDateInToday(date) {
            Text("Today")
                .font(.title2)
        } else {
            Text(date, format: .relative(presentation: .named))
                .font(.title2)
        }
    }
}

#Preview {
    UpcomingSessions(viewModel: .mock())
}

#Preview {
    UpcomingSessions(viewModel: .mock(hasBookedSessions: false))
}

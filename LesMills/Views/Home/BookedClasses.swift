//
//  ClassesToday.swift
//  LesMills
//
//  Created by Asher Foster on 7/11/23.
//

import SwiftUI

struct BookedClasses: View {
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
                List (sessions) {
                    BookedSession(session: $0)
                }
                .listStyle(.plain)
            } else {
                Text("No classes today!")
            }
        }
    }
}

#Preview {
    BookedClasses(viewModel: .mock())
}

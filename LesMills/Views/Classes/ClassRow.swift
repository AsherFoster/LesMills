//
//  ClassRow.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

struct ClassRow: View {
    
    // Les Mills booking process:
    // Is it in the past?
    // Is it within BookableTimeframeInMins (5 mins)?
    // is maxCapacity <= spacesTaken
    // if allowBookings: (allow bookings == requires preparation)
    //  prepareBookings()
    //  
    // else:
    //  addClassToSchedule()
    //  addBookingsToCalendar()
    
    var classSession: ClassSession
    
    var body: some View {
        NavigationLink {
            SessionDetail(session: classSession)
        } label: {
            HStack {
                Path(roundedRect: CGRect(x: 0, y: 0, width: 5, height: 50), cornerSize: CGSize(width: 3, height: 3))
                    .fill(classSession.color)
                    .frame(width: 5, height: 50)
                VStack(alignment: .leading) {
                    Text(classSession.startsAt, style: .time)
                    Text("\(classSession.durationMinutes) mins").foregroundStyle(.secondary)
                }
                VStack(alignment: .leading) {
                    Text(classSession.name).bold()
                    Text(classSession.instructor.name).foregroundStyle(.secondary)
                }
                Spacer()
                Button("Save Class", systemImage: "plus") {}
                    .labelStyle(.iconOnly)
            }
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    List {
        ClassRow(classSession: .mock())
    }
        .listStyle(.plain)
}

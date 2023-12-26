//
//  BookedSession.swift
//  LesMills
//
//  Created by Asher Foster on 26/12/23.
//

import SwiftUI

struct BookedSession: View {
    public var session: ClassSession
    
    var body: some View {
        HStack(spacing: 0.0) {
            VStack(alignment: .leading) {
                Text(session.name)
                    .font(.title2)
                    .bold()
                
                HStack {
                    Text(session.startsAt, formatter: CommonDateFormats.time)
                    Text("·")
                    Text("\(session.durationMinutes) mins")
                }
                    .font(.subheadline)
                    .bold()
                
                Text(session.classLocation)
                    .font(.subheadline)
                
                Text(session.instructor.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
                .padding()
                .background(.regularMaterial)
            Spacer()
        }
        .background {
            Image("TackyWorkoutPerson")
                .resizable()
                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea()
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    VStack {
        Spacer()
        BookedSession(session: .mock())
        Spacer()
    }
}

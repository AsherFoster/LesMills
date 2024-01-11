//
//  SessionDetail.swift
//  LesMills
//
//  Created by Asher Foster on 27/12/23.
//

import SwiftUI

struct DetailToken: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
            Text(value)
                .font(.subheadline)
                .bold()
        }
            .padding()
    }
}

struct SessionDetail: View {
    var session: ClassSession
    
    var body: some View {
        VStack {
            // Gradient and background is applied to the title and spacer only
            VStack {
                Spacer(minLength: 200)
                HStack {
                    Path(roundedRect: CGRect(x: 0, y: 0, width: 5, height: 30), cornerSize: CGSize(width: 3, height: 3))
                        .fill(session.color)
                        .frame(width: 5, height: 30)
                    Text(session.name)
                        .font(.largeTitle)
                        .bold()
                }
            }
                .background {
                    Image("TackyWorkoutPerson")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        .clear,
                                        Color(UIColor.systemBackground)
                                    ]
                                ),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                }
            
            // The rest of the page (including content that looks like the header) uses
            // the normal background
            HStack {
                Text(session.startsAt, formatter: CommonDateFormats.time)
                Text("·")
                Text("\(session.durationMinutes) mins")
            }
                .font(.subheadline)
                .bold()
            
            Button("Book", systemImage: "plus") {
                
            }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal) {
                    HStack {
                        DetailToken(label: "Instructor", value: session.instructor.name)
                        DetailToken(label: "Location", value: session.classLocation)
                        if session.maxCapacity > 0 {
                            DetailToken(
                                label: "Spaces",
                                value: "\(session.maxCapacity - session.spacesTaken) of \(session.maxCapacity)"
                            )
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("About \(session.name)")
                    NotImplementedView()
                        .frame(maxWidth: .infinity)
                }
                    .padding()
            }
        }
    }
}

#Preview {
    SessionDetail(session: .mock())
}

import SwiftUI

struct BookedSession: View {
    public var session: ClassSession
    
    var body: some View {
        NavigationLink(value: session) {
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
                    .frame(minWidth: 250, alignment: .leading)
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
            .foregroundStyle(.primary)
        }
        .contextMenu {
            ShareLink(item: session.shareText)
            Button("Remove booking", systemImage: "trash", role: .destructive) {
                Task {
//                    let request = Paths.removeBooking(classSession: session)
//                    try await client.send(request)
                }
            }
        }
    }
}

#Preview {
    VStack {
        BookedSession(session: .mock())
        
        NavigationStack {
            // TODO stop being blue please
            BookedSession(session: .mock())
        }
        
        List {
            BookedSession(session: .mock())
        }
            .listStyle(.plain)
    }
}

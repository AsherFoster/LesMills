import SwiftUI
import Factory

struct ClassRow: View {
    var session: ClassSession
    
    var body: some View {
        NavigationLink {
            SessionDetail(session: session)
        } label: {
            HStack {
                Path(roundedRect: CGRect(x: 0, y: 0, width: 5, height: 50), cornerSize: CGSize(width: 3, height: 3))
                    .fill(session.color)
                    .frame(width: 5, height: 50)
                VStack(alignment: .leading) {
                    Text(session.startsAt, style: .time)
                    Text("\(session.durationMinutes) mins").foregroundStyle(.secondary)
                }
                VStack(alignment: .leading) {
                    Text(session.name).bold()
                    Text(session.instructor.name).foregroundStyle(.secondary)
                }
                Spacer()
                BookClassButton(session: session)
                    .labelStyle(.iconOnly)
            }
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    List {
        ClassRow(session: .mock())
    }
        .listStyle(.plain)
}

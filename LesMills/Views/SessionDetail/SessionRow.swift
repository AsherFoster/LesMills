import SwiftUI
import Factory

struct SessionRow: View {
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
                    Text(session.duration.converted(to: .minutes).formatted())
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 80, alignment: .leading)
                VStack(alignment: .leading) {
                    Text(session.name).bold()
                    Text(session.instructor).foregroundStyle(.secondary)
                }
                Spacer()
                BookSessionButton(session: session)
                    .labelStyle(.iconOnly)
            }
                .foregroundStyle(.primary)
                .opacity(session.startsAt < Date.now ? 0.5 : 1)
        }
    }
}

#Preview {
    List {
        SessionRow(session: .mock())
    }
        .listStyle(.plain)
}

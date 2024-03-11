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
                    Text(session.serviceName)
                        .font(.largeTitle)
                        .bold()
                }
                    .frame(maxWidth: .infinity)
            }
                .background {
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
                .background {
                    Image("TackyWorkoutPerson")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            
            // The rest of the page (including content that looks like the header) uses
            // the normal background
            HStack {
                Text(session.startsAt, formatter: CommonDateFormats.time)
                Text("·")
                Text(session.duration.converted(to: .minutes).formatted())
            }
                .font(.subheadline)
                .bold()
            
            BookSessionButton(session: session)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            
            VStack(alignment: .leading) {
                ScrollView(.horizontal) {
                    HStack {
                        DetailToken(label: "Instructor", value: session.instructor)
                        DetailToken(label: "Location", value: session.location)
                        if session.maxCapacity > 0 {
                            DetailToken(
                                label: "Spaces",
                                value: "\(session.maxCapacity - session.spacesTaken) of \(session.maxCapacity)"
                            )
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("About \(session.classType.name)")
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

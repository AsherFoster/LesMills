import SwiftUI

struct NextClasses: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Next classes")
                    .font(.title2)
                Text(try! AttributedString(markdown: "At **Taranaki Street**"))
                    .font(.subheadline)
            }
            Spacer()
            NavigationLink {
                TimetableView()
            } label: {
                HStack {
                    Text("More")
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.bold())
            }
        }
    }
}

#Preview {
    NextClasses(viewModel: .mock())
}

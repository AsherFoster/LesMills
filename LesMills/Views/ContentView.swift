import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RootViewModel()
    
    @ViewBuilder
    var body: some View {
        if viewModel.isReady {
            if let error = viewModel.error {
                Text(error)
            } else if let profile = viewModel.profile {
                AuthenticatedView(profile: profile)
                .preferredColorScheme(.dark)
                .background(.background)
            } else {
                LoginView()
            }
        } else {
            ProgressView()
        }
    }
}


#Preview {
    ContentView()
}

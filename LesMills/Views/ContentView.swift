import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RootViewModel()
    
    var body: some View {
        Group {
            if viewModel.isReady {
                if let error = viewModel.error {
                    Text(error)
                } else if viewModel.isAuthenticated {
                    AuthenticatedView()
                    .preferredColorScheme(.dark)
                    .background(.background)
                } else {
                    LoginView()
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.startup()
        }
    }
}


#Preview {
    ContentView()
}

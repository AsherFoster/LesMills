import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RootViewModel()
    
    @ViewBuilder
    var body: some View {
        mainView
            .environmentObject(viewModel)
            .preferredColorScheme(.dark)
    }
    
    @ViewBuilder
    var mainView: some View {
        if viewModel.isReady {
            if let error = viewModel.error {
                Text(error)
            } else if viewModel.isAuthenticated {
                NavigationStack {
                    AuthenticatedView()
                }
            } else {
                LoginView()
            }
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        await viewModel.load()
                    }
                }
        }
    }
}


#Preview {
    ContentView()
}

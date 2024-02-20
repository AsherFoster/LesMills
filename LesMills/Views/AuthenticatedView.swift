import SwiftUI

struct AuthenticatedView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            if !viewModel.isLoading {
                HomeView(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    AuthenticatedView()
}

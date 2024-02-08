import SwiftUI
import Factory

struct AccountView: View {
    @StateObject private var viewModel = AccountViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.profile != nil {
                    AccountLoadedView(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .task {
                await viewModel.loadData()
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
}

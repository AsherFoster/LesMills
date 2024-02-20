import SwiftUI

struct AuthenticatedView: View {
    init(profile: UserProfile) {
        _viewModel = StateObject(wrappedValue: MainViewModel(profile: profile))
    }
    
    @StateObject var viewModel: MainViewModel
    @State var isBarcodeShown = false
    
    var body: some View {
        VStack {
            TimetableView(viewModel: viewModel)
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem {
                Button {
                    isBarcodeShown.toggle()
                } label: {
                    Label("Show barcode", systemImage: "barcode.viewfinder")
                }
                .sheet(isPresented: $isBarcodeShown) {
                    BarcodeSheet(profile: viewModel.profile)
                }
            }
            ToolbarItem {
                NavigationLink {
                    AccountView()
                } label: {
                    Label("Account", systemImage: "person.circle")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            NextClassSnackbar(session: viewModel.bookedSessions?.first, profile: viewModel.profile)
        }
    }
}

#Preview {
    AuthenticatedView(profile: .mock())
}

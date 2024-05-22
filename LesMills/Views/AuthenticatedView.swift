import SwiftUI

struct AuthenticatedView: View {
    @EnvironmentObject var rootModel: RootViewModel
    @StateObject var viewModel = MainViewModel()
    
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
                NextClassSnackbar()
                    .padding(.horizontal)
                    .padding(.top)
                    .background(.linearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom))
            }
            .onAppear {
                Task {
                    await viewModel.load(rootModel: rootModel)
//                    viewModel.timetable = .mock()
                }
            }
    }
}

#Preview {
    NavigationStack {
        AuthenticatedView()
            .environmentObject(RootViewModel.mock())
    }
}

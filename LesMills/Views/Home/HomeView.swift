import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var isBarcodeShown = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Kia ora, \(viewModel.profile!.firstName)")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Group {
                    Button("Show barcode", systemImage: "barcode.viewfinder") {
                        isBarcodeShown.toggle()
                    }
                    .sheet(isPresented: $isBarcodeShown) {
                        BarcodeSheet(profile: viewModel.profile!)
                    }
                    NavigationLink {
                        AccountView()
                    } label: {
                        Label("Account", systemImage: "person.circle")
                            .foregroundStyle(.accent)
                    }
                }
                .controlSize(.large)
                .labelStyle(.iconOnly)
            }
            .padding()
            
            TimetableView()
        }
        .safeAreaInset(edge: .bottom) {
            NextClassSnackbar(session: viewModel.bookedSessions?.first, profile: viewModel.profile!)
        }
    }
}

#Preview {
    HomeView(viewModel: .mock())
}

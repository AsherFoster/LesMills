import SwiftUI
import Factory

struct AccountView: View {
    @EnvironmentObject private var rootModel: RootViewModel
    
    var body: some View {
        Group {
            if let profile = rootModel.profile {
                AccountLoadedView(profile: profile)
            } else {
                // TODO this should be impossible
                ProgressView()
            }
        }
        .navigationTitle("Account")
    }
}

#Preview {
    AccountView()
}

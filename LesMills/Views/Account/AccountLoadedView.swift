import SwiftUI

struct AccountProfileView: View {
    @StateObject var viewModel: AccountViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            Text(profileEmoji)
                .font(.largeTitle)
                .padding(8)
                .background(
                    Circle()
                        .foregroundStyle(.orange)
                        .opacity(0.3)
                )
            VStack(alignment: .leading) {
                Text(viewModel.profile!.firstName)
                    .font(.title2)
                Text("Update Details")
                    .font(.subheadline)
            }
        }
    }
    
    var profileEmoji: String {
        let names: [String] = ["🤠", "🫠", "😤", "🥸", "🤔", "🫣", "🤩", "🤯", "🥳", "🥺", "👽", "🤖"]
        
        // Implement a FNV1a PRNG algorithm suggested by ChatGPT
        var result: UInt64 = 14695981039346656037
        for byte in Array((viewModel.profile?.firstName ?? "TODO").utf8) {
            result ^= UInt64(byte)
            result &*= 1099511628211
        }

        return names[abs(Int(truncatingIfNeeded: result)) % names.count]
    }
}


struct AccountLoadedView: View {
    @ObservedObject var viewModel: AccountViewModel
    
    var profile: UserProfile { viewModel.profile! }
    
    func profileBool(path: WritableKeyPath<UserProfileDraft, Bool>) -> Binding<Bool> {
        return Binding(
            get: { viewModel.draftProfile![keyPath: path] },
            set: {
                viewModel.draftProfile![keyPath: path] = $0
                Task {
                    try await viewModel.saveDraftProfile()
                }
            }
        )
    }
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    AccountDetailsView(viewModel: viewModel)
                } label: {
                    AccountProfileView(viewModel: viewModel)
                }
            }
            Section(header: Text("Notifications")) {
                Toggle(isOn: profileBool(path: \.sendPushNotifications)) {
                    Text("Push Notifications")
                }
                Toggle(isOn: profileBool(path: \.sendClassReminders)) {
                    Text("Class Reminders")
                }
                Toggle(isOn: profileBool(path: \.saveClassesToCalendar)) {
                    Text("Save Classes to Calendar")
                }
                Toggle(isOn: profileBool(path: \.sendMarketingEmails)) {
                    Text("Send Marketing Emails")
                }
                Toggle(isOn: .constant(false)) {
                    Text("Quick Beacon Barcode")
                }
            }
            Section(header: Text("About Les Mills")) {
                AccountLinkView(
                    label: "Contact Us",
                    url: URL(string: "https://www.lesmills.co.nz/contact")!
                )
                AccountLinkView(
                    label: "Personal Training",
                    url: URL(string: "https://www.lesmills.co.nz/trainers/")!
                )
                
                NavigationLink {
                    NotImplementedView()  // TODO implement
                } label: {
                    Text("Clubs")
                }
                AccountLinkView(
                    label: "Club News",
                    url: URL(string: "https://www.lesmills.co.nz/journal/club-news")!
                )
                AccountLinkView(
                    label: "Les Mills Music",
                    url: URL(string: "https://open.spotify.com/user/lesmillsnewzealand")!
                )
                AccountLinkView(
                    label: "Group Fitness",
                    url: URL(string: "https://www.lesmills.co.nz/group-fitness")!
                )
            }
            Section(header: Text("About")) {
                NavigationLink {
                    NotImplementedView()  // TODO implement
                } label: {
                    Text("Terms of Use")
                }
                NavigationLink {
                    NotImplementedView()  // TODO implement
                } label: {
                    Text("Open Source Licenses")
                }
                HStack {
                    Text("App Version")
                    Spacer()
                    Text(currentAppVersion)
                }
            }
            
            Section {
                Button("Sign out", role: .destructive) {
                    try! viewModel.client.signOut() // TODO error handling
                }
            }
            
            Section {
                Link("Made with Spite by Asher", destination: URL(string: "https://asherfoster.com")!)
            }
        }
    }
}

#Preview {
    AccountLoadedView(viewModel: .mock())
}

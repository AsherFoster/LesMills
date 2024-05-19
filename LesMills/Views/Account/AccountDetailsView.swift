import SwiftUI

struct AccountDetailsView: View {
    @ObservedObject var viewModel: AccountViewModel
    
    var profile: UserProfile { viewModel.profile }
    
    var body: some View {
        VStack {
            Section {
                TextField("Member ID", text: Binding.constant(String(profile.lesMillsID)))
                TextField("Password", text: Binding.constant("TODO"))
            }
            
            Section("Name") {
                TextField("First", text: Binding.constant(profile.firstName))
                TextField("Last", text: Binding.constant(profile.lastName))
            }
            
            Section("Details") {
                TextField("Phone", text: Binding.constant(profile.mobilePhone))
                TextField("Email", text: Binding.constant(profile.email))
                TextField("Birth date", text: Binding.constant(profile.dateOfBirth))
            }
            
            Section("Address") {
                TextField("Street", text: Binding.constant(profile.addressLine1))
                TextField("Suburb", text: Binding.constant(profile.addressSuburb))
                TextField("City", text: Binding.constant(profile.addressCity))
                TextField("Postcode", text: Binding.constant(profile.addressPostcode))
            }
            
            Section("Emergency contact") {
                TextField("Name", text: Binding.constant(profile.emergencyContactName))
                TextField("Phone", text: Binding.constant(profile.emergencyContactPhone))
            }
        }
        .textFieldStyle(.roundedBorder)
        .navigationTitle("Update details")
    }
}

#Preview {
    AccountDetailsView(viewModel: .mock())
}

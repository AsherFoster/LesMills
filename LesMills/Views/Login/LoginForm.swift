import SwiftUI
import Factory

class LoginViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient
    
    @Published var isLoading = false
    @Published private var error: String? = nil
    
    func login(memberId: String, password: String) async -> UserProfile? {
        await MainActor.run {
            isLoading = true
        }
        var profile: UserProfile?
        do {
            let resp = try await client.signIn(memberId: memberId, password: password)
            profile = resp.contactDetails
        } catch {
            await MainActor.run {
                self.error = "\(error)"
            }
        } 
        await MainActor.run {
            isLoading = false
        }
        return profile
    }    
}

struct LoginForm: View {
    @EnvironmentObject var rootModel: RootViewModel
    @StateObject var viewModel = LoginViewModel()
    
    @State private var memberId: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Sign in to Les Mills")
                .font(.largeTitle)
            
            TextField("Member ID", text: $memberId)
                .textFieldStyle(LesMillsTextFieldStyle())
                .keyboardType(.decimalPad)
                
            SecureField("Password", text: $password)
                .textFieldStyle(LesMillsTextFieldStyle())
            
            Button() {
                Task {
                    if let profile = await viewModel.login(memberId: memberId, password: password) {
                        rootModel.doneLogin(profile: profile)
                    }
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.small)
                        .frame(maxWidth: .infinity, maxHeight: 20.0)
                } else {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                }
            }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                NavigationLink {
                    ForgotView()
                } label: {
                    Text("Forgot ID")
                }
                Spacer()
                Link("Sign up", destination: URL(string: "https://www.lesmills.co.nz/memberships")!)
                Spacer()
            }
        }
        .disabled(viewModel.isLoading)
        .padding()
    }
}

#Preview {
    LoginForm()
        .background(.regularMaterial)
}

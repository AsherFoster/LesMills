//
//  LoginForm.swift
//  LesMills
//
//  Created by Asher Foster on 18/10/23.
//

import SwiftUI

class LoginViewModel: ViewModel {
    @Published private var error: String? = nil
    
    func login(memberId: String, password: String) async {
        isLoading = true
        do {
            try await client.signIn(memberId: memberId, password: password)
        } catch {
            self.error = "\(error)"
        }
        isLoading = false
    }
    
}

struct LoginForm: View {
    @StateObject var model = LoginViewModel()
    
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
                    await model.login(memberId: memberId, password: password)
                }
            } label: {
                if model.isLoading {
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
                    NotImplementedView()
                } label: {
                    Text("Forgot ID")
                }
                Spacer()
                NavigationLink {
                    NotImplementedView()
                } label: {
                    Text("Sign up")
                }
                Spacer()
            }
        }
        .disabled(model.isLoading)
        .padding()
        
    }
}

#Preview {
    LoginForm()
        .background(.regularMaterial)
}

//
//  LoginForm.swift
//  LesMills
//
//  Created by Asher Foster on 18/10/23.
//

import SwiftUI

struct LoginForm: View {
    @State private var memberId: String = ""
    @State private var password: String = ""
    
    @Environment(\.lesMillsClient) private var client: LesMillsClient
    @State private var isLoading: Bool = false
    @State private var error: String? = nil
    
    private func login() async {
        isLoading = true
        do {
            try await client.login(memberId: memberId, password: password)
        } catch {
            self.error = "\(error)"
        }
        isLoading = false
    }
    
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
                    await login()
                }
            } label: {
                if isLoading {
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
        .disabled(isLoading)
        .padding()
        
    }
}

#Preview {
    LoginForm()
        .background(.regularMaterial)
}

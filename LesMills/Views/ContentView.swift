//
//  ContentView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var isAuthenticated: Bool {
        print("Token is \(viewModel.client.apiToken?.uuidString ?? "not set")")
        return viewModel.client.apiToken != nil
    }
    
    
    var body: some View {
        Group {
            if isAuthenticated {
                AuthenticatedView()
                .preferredColorScheme(.dark)
                .background(.background)
            } else {
                LoginView()
            }
        }
        .task {
//            await viewModel.tryResumeSession()
        }
    }
}


#Preview {
    ContentView()
}

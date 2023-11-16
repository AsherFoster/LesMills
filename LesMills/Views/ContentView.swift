//
//  ContentView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    @State var isAuthenticated = false
//    @State var isAuthenticated: Bool {
//        return viewModel.client.apiToken != nil
//    }
    
    
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
        .onAppear {
            do {
                if try viewModel.client.signInFromStorage() {
                    isAuthenticated = true
                }
            } catch {
                //
            }
        }
    }
}


#Preview {
    ContentView()
}

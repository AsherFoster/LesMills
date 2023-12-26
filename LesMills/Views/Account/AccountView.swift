//
//  AccountView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI
import Factory

struct AccountView: View {
    @Injected(\.client)
    var client
    
    @StateObject private var viewModel: AccountViewModel = .init()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.profile != nil {
                    AccountLoadedView(viewModel: viewModel)
                } else {
                    ProgressView()
                }
            }
            .task {
                await viewModel.loadData()
            }
            .navigationTitle("Account")
        }
    }
}

#Preview {
    AccountView()
}

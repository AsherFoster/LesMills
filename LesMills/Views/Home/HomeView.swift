//
//  HomeView.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = .init()
    
    @ViewBuilder
    var body: some View {
        VStack {
            if !viewModel.isLoading, let profile = viewModel.profile {
                NavigationStack {
                    VStack(alignment: .leading) {
                        Text("Kia ora, \(profile.firstName)")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)
                        
                        Text("Today")
                            .font(.title2)
                        BookedClasses(viewModel: viewModel)
                        
                        ShowBarcode(profile: profile)

                        
                        NextClasses(viewModel: viewModel)


                        Spacer()
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
                //            .navigationTitle("Home")
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

//
//  HomeView.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

class HomeViewModel: ViewModel {
    @Published var profile: UserContactDetails? = nil
//    @Published var classesToday: [ClassInstance]? = nil
    
    func loadData() {
        isLoading = true
        
        Task {
            do {
                let request = Paths.getDetails()
                let contactDetails = try await client.send(request).value.contactDetails
                
                await MainActor.run {
                    profile = contactDetails
                }
            } catch {
                // TODO :shrug:
                print("Failed to load HomeViewModel \(error)")
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

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
                        
                        Button("Show barcode", systemImage: "barcode") {}
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.bordered)
                            .controlSize(.large)

                        
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

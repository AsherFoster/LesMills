//
//  HomeView.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

class HomeViewModel: ViewModel {
    @Published var profile: UserContactDetails? = nil
    @Published var classesToday: [ClassInstance]? = nil
    
    func loadData() async {
        self.isLoading = true
        
        do {
            let request = Paths.getDetails()
            profile = try await client.send(request).value.contactDetails
        } catch {
            // TODO :shrug:
            print("Failed to load HomeViewModel \(error)")
        }
        
        self.isLoading = false
    }
}

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    @ViewBuilder
    var body: some View {
        Group {
            if !viewModel.isLoading, let profile = viewModel.profile {
                NavigationStack {
                    VStack(alignment: .leading) {
                        Text("Kia ora, \(profile.firstName)")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)
                        Text("Today")
                            .font(.title2)
                        Group{}
                        Button("Show barcode", systemImage: "barcode") {}
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Next classes")
                                    .font(.title2)
                                Text(try! AttributedString(markdown: "At **Taranaki Street**"))
                                    .font(.subheadline)
                            }
                            Spacer()
                            NavigationLink {
                                ClassesView()
                            } label: {
                                HStack {
                                    Text("More")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.subheadline.bold())
                            }
                        }
                        ClassesToday()
                        
                        
                        Spacer()
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
                //            .navigationTitle("Home")

        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}

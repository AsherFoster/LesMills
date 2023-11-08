//
//  HomeView.swift
//  LesMills
//
//  Created by Asher Foster on 26/09/23.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var profile: UserContactDetails? = nil
    @Published var classesToday: [ClassInstance]? = nil
    @Published var isLoading: Bool = false
    
    
    func loadData(client: LesMillsClient) async {
        // TODO passing client in here feels sooo wrong
        self.isLoading = true
        
        do {
            profile = try await client.getUserContactDetails()
        } catch {
            // TODO :shrug:
            print("Failed to load HomeViewModel \(error)")
        }
        
        self.isLoading = false
    }
}

struct HomeView: View {
    @Environment(\.lesMillsClient) var client: LesMillsClient
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @ViewBuilder
    var body: some View {
        Group {
            if !homeViewModel.isLoading, let profile = homeViewModel.profile {
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
            await homeViewModel.loadData(client: client)
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
        .environment(\.lesMillsClient, MockLesMillsClient())
}

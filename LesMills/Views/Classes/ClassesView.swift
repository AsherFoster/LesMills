//
//  ClassesView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

class ClassesViewModel: ViewModel {
    @Published var profile: UserContactDetails? = nil
    @Published public var selectedClubs: Set<ClubDetailPage> = []
    @Published public var allClubs: [ClubDetailPage] = []
    
    func loadData() {
        isLoading = true
        
        Task {
            do {
                let clubsResponse = try await client.send(Paths.getClubs()).value
                let contactDetails = try await client.send(Paths.getDetails()).value.contactDetails
                
                await MainActor.run {
                    profile = contactDetails
                    allClubs = clubsResponse.map { $0.clubDetailPage }
                    selectedClubs = Set(allClubs.filter { $0.id == profile?.homeClubGuid})
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

struct FilterChip<Content: View>: View {
    public var label: String
    public var selectValue: () -> Content
    
    @State private var filterOpen = false
    
    var body: some View {
        Button {
            filterOpen.toggle()
        } label: {
            HStack {
                Text(label)
                Image(systemName: "chevron.down")
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
        .sheet(isPresented: $filterOpen) {
            selectValue()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}


struct ClassesViewHeader: View {
    @StateObject private var viewModel: ClassesViewModel  = .init()
    
    var body: some View {
        VStack {
            HStack {
                Button {} label: {
                    HStack {
                        Text("Today")
                        Image(systemName: "chevron.right")
                    }
                }
                Spacer()
                
                Button("Previous Day", systemImage: "chevron.left") {}
                    .labelStyle(.iconOnly)
                    .disabled(true)
                Button("Next Day", systemImage: "chevron.right") {}
                    .labelStyle(.iconOnly)
            }
            .padding(.bottom)
            
            HStack {
                FilterChip(label: "Clubs") {
                    List(viewModel.allClubs, id: \.id, selection: $viewModel.selectedClubs) { club in
                        Button(club.nodeName) {
                            if self.viewModel.selectedClubs.contains(club) {
                                self.viewModel.selectedClubs.remove(club)
                            } else {
                                self.viewModel.selectedClubs.insert(club)
                            }
                        }
                    }
                }
                Button(action: {}) {
                    HStack {
                        Text("Instructor")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                Button(action: {}) {
                    HStack {
                        Text("Class")
                        Image(systemName: "chevron.down")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Spacer()
            }
        }
        .padding(.all)
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct ClassesView: View {
    var body: some View {
        NavigationStack {
            ClassesViewHeader()
            Section {
                List([ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock(), ClassInstance.mock()]) {
                    ClassRow(classInstance: $0)
                }
                .listStyle(.plain)
            }
//            .toolbar {
//                ToolbarItemGroup {
//                    Button("Previous Day", systemImage: "chevron.left") {}
//                    Button("Next Day", systemImage: "chevron.right") {}
//                }
//            }
            .navigationTitle("Classes")
        }
    }
}

#Preview {
    ClassesView()
}

//
//  ClassesView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct FilterChip<Content: View>: View {
    public var label: String
    public var active: Bool
    public var selectValue: () -> Content
    
    @State private var filterOpen = false
    
    @ViewBuilder
    var body: some View {
        if active {
            base
                .buttonStyle(.borderedProminent)
        } else {
            base
                .buttonStyle(.bordered)
        }
    }
    
    var base: some View {
        Button {
            filterOpen.toggle()
        } label: {
            HStack {
                Text(label)
                Image(systemName: "chevron.down")
            }
        }
        .controlSize(.small)
        .sheet(isPresented: $filterOpen) {
            selectValue()
                .presentationDragIndicator(.visible)
        }
    }
}


struct ClassesViewHeader: View {
    @ObservedObject var viewModel: ClassesViewModel
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter
    }
    
    var body: some View {
        VStack {
            ClassesViewFilters(viewModel: viewModel)
            
            if let dates = viewModel.timetableDates {
                ScrollView(.horizontal) {
                    Picker("Date", selection: $viewModel.selectedDate) {
                        ForEach(dates, id: \.self) {
                            Text(dateFormatter.string(from: $0))
                        }
                    }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 16)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .background {
                        Rectangle()
                            .fill(.quinary)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
                    }
                    .padding(.vertical, 16)
            }
        }
    }
}

struct ClassesView: View {
    @StateObject private var viewModel: ClassesViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ClassesViewHeader(viewModel: viewModel)
                .padding(.horizontal)
                .padding(.top)
            Section {
                classes
                Spacer()
            }
                .navigationTitle("Classes")
                .onAppear {
                    viewModel.loadData()
                }
        }
    }
    
    @ViewBuilder
    var classes: some View {
        if !viewModel.isLoading, let timetableDates = viewModel.timetableDates {
            PageViewController(
                pages: timetableDates.map {
                    sessionList(date: $0)
                },
                currentPage: Binding(
                    get: {
                        timetableDates.firstIndex(of: viewModel.selectedDate)!
                    },
                    set: {
                        viewModel.selectedDate = timetableDates[$0]
                    }
                )
            )
        } else {
            ProgressView()
        }
    }
    
    func sessionList(date: Date) -> some View {
        List(viewModel.filteredSessions(forDate: date)) {
            ClassRow(classSession: $0)
        }
        .listStyle(.plain)
        .refreshable {
            try! await viewModel.refreshTimetable()
        }
    }
}

#Preview {
    ClassesView()
}

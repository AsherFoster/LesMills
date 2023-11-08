//
//  ClassesToday.swift
//  LesMills
//
//  Created by Asher Foster on 7/11/23.
//

import SwiftUI

struct ClassesToday: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var classesToday: [ClassInstance]? = nil
    
    var body: some View {
        VStack {
            if classesToday != nil {
                List (classesToday!) {
                    ClassRow(classInstance: $0)
                }
                .listStyle(.plain)
            } else {
                ProgressView()
            }
        }
        .task{
            await loadData()
        }
    }
    
    func loadData() async {
//        try await client.getUserContactDetails()
        //            classesToday = await client.getUpcomingClasses()
    }
}

#Preview {
    ClassesToday()
}

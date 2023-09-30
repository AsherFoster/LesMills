//
//  ContentView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home
        case account
        case classes
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(classesToday: [.mock])
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(Tab.home)
            ClassesView()
                .tabItem {
                    Label("Classes", systemImage: "calendar")
                }
                .tag(Tab.classes)
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(Tab.account)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

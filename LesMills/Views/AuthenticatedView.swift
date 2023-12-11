//
//  AuthenticatedView.swift
//  LesMills
//
//  Created by Asher Foster on 28/10/23.
//

import SwiftUI

struct AuthenticatedView: View {
    @State private var selectedTab: Tab = .home
     
    enum Tab {
        case home
        case account
        case classes
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
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
    AuthenticatedView()
}

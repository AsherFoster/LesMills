//
//  ContentView.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import SwiftUI

struct ContentView: View {
    var client: LesMillsClient = LesMillsHTTPClient()
    
    @State private var isAuthenticated: Bool = false
    
    var body: some View {
        Group {
            if isAuthenticated {
                AuthenticatedView()
                .preferredColorScheme(.dark)
                .background(.background)
                .environment(\.lesMillsClient, client)
            } else {
                VStack {
                    Button("crimes crimes crimes") {
                        isAuthenticated = client.isAuthenticated
                    }
                    LoginView()
                }
            }
        }
        .task {
            await client.tryResumeSession()
        }
    }
}

struct LesMillsClientKey: EnvironmentKey {
    static let defaultValue: LesMillsClient = LesMillsHTTPClient()
}

extension EnvironmentValues {
    var lesMillsClient: LesMillsClient {
        get { self[LesMillsClientKey.self] }
        set { self[LesMillsClientKey.self] = newValue }
    }
}


#Preview {
    ContentView()
}

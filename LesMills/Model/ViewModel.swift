//
//  ViewModel.swift
//  LesMills
//
//  Created by Asher Foster on 8/11/23.
//

import Foundation
import Factory

extension Container {
    // What does this do? I have no idea lmao
    var client: Factory<LesMillsClient> {
        Factory(self) {
            let c = LesMillsClient()
//            try? c.signInFromStorage()
            return c
        }
            .singleton
    }
}

class ViewModel: ObservableObject {
    @Injected(\.client)
    var client


    @Published
    var isLoading = false
}

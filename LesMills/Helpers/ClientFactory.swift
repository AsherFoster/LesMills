//
//  ClientFactory.swift
//  LesMills
//
//  Created by Asher Foster on 8/02/24.
//

import Foundation
import Factory

extension Container {
    // What does this do? I have no idea lmao
    var client: Factory<LesMillsClient> {
        Factory(self) {
            return LesMillsClient()
        }
            .singleton
    }
}

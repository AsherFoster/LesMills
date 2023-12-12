//
//  CheckContactExists.swift
//  LesMills
//
//  Created by Asher Foster on 8/11/23.
//

import Foundation
import Get

struct CheckContactExistsRequest: Codable, Hashable {
    let lesMillsID: String
    
    public var asQuery: [(String, String?)] {
        return [
            ("lesMillsID", lesMillsID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
    }
}

struct CheckContactExistsResponse: Codable, Hashable {
    // My account returns "Tango", but presumably there are other values?
    let contactType: String
}

extension Paths {
    static func checkContactExists(memberId: String) -> Request<CheckContactExistsResponse> {
        Request(
            path: "/User/CheckContactExists",
            method: "GET",
            query: CheckContactExistsRequest(lesMillsID: memberId).asQuery,
            id: "CheckContactExists"
        )
    }
}

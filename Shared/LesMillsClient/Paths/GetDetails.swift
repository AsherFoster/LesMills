//
//  GetDetails.swift
//  LesMills
//
//  Created by Asher Foster on 8/11/23.
//

import Foundation
import Get

struct GetDetailsResponse: Codable, Hashable {
    let contactDetails: UserContactDetails
}

extension Paths {
    static func getDetails() -> Request<GetDetailsResponse> {
        Request(path: "/User/GetDetails", method: "GET", id: "GetDetails")
    }
}

//
//  GetInstructors.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Foundation
import Get

struct BasicInstructor: Codable, Hashable, Identifiable {
    let name: String
    
    var id: String {
        name
    }
    
    enum CodingKeys: String, CodingKey {
        // I mean, come on Les Mills...
        case name = "item1"
    }
}

struct GetInstructorsRequest {
    let clubs: [String]
    
    public var asQuery: [(String, String?)] {
        return [
            ("searchClubCodes", clubs.joined(separator: ","))
        ]
    }
}

extension Paths {
    /// Get a list of all instructors that run classes at a set of clubs (name only)
    static func getInstructors(clubs: Set<DetailedClub>) -> Request<[BasicInstructor]> {
        Request(
            path: "/LesMillsData/GetInstructors",
            method: "GET",
            query: GetInstructorsRequest(clubs: clubs.map { $0.id }).asQuery,
            id: "GetInstructors"
        )
    }
}

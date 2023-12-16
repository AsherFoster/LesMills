//
//  GetClubs.swift
//  LesMills
//
//  Created by Asher Foster on 10/12/23.
//

import Foundation
import Get

struct ClubItem: Codable, Hashable {
    let clubDetailPage: DetailedClub
}
typealias GetClubsResponse = [ClubItem]


extension Paths {
    /// Retreive a detailed list of all Les Mills Clubs
    static func getClubs() -> Request<GetClubsResponse> {
        Request(path: "/LesMillsData/GetClubs", method: "GET", id: "GetClubs")
    }
}

import Foundation
import Get

struct GetClubsResponseItem: Codable, Hashable {
    let clubDetailPage: DetailedClub
}
typealias GetClubsResponse = [GetClubsResponseItem]


extension Paths {
    /// Retreive a detailed list of all Les Mills Clubs
    static func getClubs() -> Request<GetClubsResponse> {
        Request(path: "/LesMillsData/GetClubs", method: "GET", id: "GetClubs")
    }
}

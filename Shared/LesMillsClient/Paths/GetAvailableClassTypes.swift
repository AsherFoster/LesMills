import Foundation
import Get

struct APIClassType: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        // Les Mill's API gives strong "it technically works and that's technically good enough" vibes
        case id = "item1"
        case name = "item2"
    }
}

struct GetAllClassesRequest {
    let clubs: [String]
    
    public var asQuery: [(String, String?)] {
        return [
            ("searchClubCodes", clubs.joined(separator: ","))
        ]
    }
}

extension Paths {
    /// Get a list of all class types that run at a set of clubs (name only)
    static func getAvailableClassTypes(clubs: Set<DetailedClub>) -> Request<[APIClassType]> {
        Request(
            path: "/LesMillsData/GetAllClasses",
            method: "GET",
            query: GetAllClassesRequest(clubs: clubs.map { $0.id }).asQuery,
            id: "GetAllClasses"
        )
    }
}

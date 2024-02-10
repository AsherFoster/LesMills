import Foundation
import Get

struct GetDetailsResponse: Codable, Hashable {
    let contactDetails: UserProfile
}

extension Paths {
    static func getDetails() -> Request<GetDetailsResponse> {
        Request(path: "/User/GetDetails", method: "GET", id: "GetDetails")
    }
}

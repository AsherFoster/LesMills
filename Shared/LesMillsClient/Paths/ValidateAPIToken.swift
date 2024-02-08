import Foundation
import Get

struct ValidateAPITokenResponse: Codable, Hashable {
    let message: String
}

extension Paths {
    // Valid: 200, API token is valid.
    // Invalid: 500, An error has occurred.
    static func validateAPIToken() -> Request<ValidateAPITokenResponse> {
        Request(path: "/User/ValidateAPIToken", method: "GET", id: "ValidateAPIToken")
    }
}

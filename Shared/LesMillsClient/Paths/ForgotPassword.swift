import Foundation
import Get

struct ForgotPasswordRequest: Codable, Hashable {
    let id: String
}
struct ForgotPasswordResponse: Codable, Hashable {
    let memberEmail: String
}

extension Paths {
    // Valid: 200, memberEmail is empty string
    // Invalid: 400: message is NotVaildLesMillsIDOrEmail
    static func forgotPassword(memberIdOrEmail: String) -> Request<ForgotPasswordResponse> {
        Request(path: "/User/ForgotPasswordSendEmail", method: "POST", body: ForgotPasswordRequest(id: memberIdOrEmail), id: "ForgotPassword")
    }
}

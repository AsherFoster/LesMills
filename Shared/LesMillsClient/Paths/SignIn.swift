import Foundation
import Get

struct SignInRequest: Codable, Hashable {
    let lesMillsID: String
    let password: String
}
struct SignInResponse: Codable, Hashable {
    let contactDetails: UserProfile
    let message: String
    
    static func mock() -> SignInResponse {
        SignInResponse(contactDetails: .mock(), message: "")
    }
}

extension Paths {
   static func signIn(memberId: String, password: String) -> Request<SignInResponse> {
        Request(path: "/User/SignIn", method: "POST", body: SignInRequest(lesMillsID: memberId, password: password), id: "SignIn")
    }
}

//
//  ForgotPassword.swift
//  LesMills
//
//  Created by Asher Foster on 8/11/23.
//

import Foundation
import Get

struct ForgotPasswordRequest: Codable, Hashable {
    var id: String
}
struct ForgotPasswordResponse: Codable, Hashable {
    var memberEmail: String
}

extension Paths {
    // Valid: 200, memberEmail is empty string
    // Invalid: 400: message is NotVaildLesMillsIDOrEmail
    static func forgotPassword(memberIdOrEmail: String) -> Request<ForgotPasswordResponse> {
        Request(path: "/User/ForgotPasswordSendEmail", method: "POST", body: ForgotPasswordRequest(id: memberIdOrEmail), id: "ForgotPassword")
    }
}

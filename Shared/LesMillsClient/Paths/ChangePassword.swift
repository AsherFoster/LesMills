//
//  ChangePassword.swift
//  LesMills
//
//  Created by Asher Foster on 8/11/23.
//

import Foundation
import Get

struct ChangePasswordRequest: Codable, Hashable {
    var currentPassword: String
    var newPassword: String
}

struct ChangePasswordResponse: Codable, Hashable {
    var apiToken: String
}

extension Paths {
    // Note: on success this will change the user's API token!
    // TODO We should probably handle either updating the client or logging the user out
    static func changePassword(currentPassword: String, newPassword: String) -> Request<ChangePasswordResponse> {
        Request(path: "/User/ChangePassword", method: "POST", body: ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword), id: "ChangePassword")
    }
}

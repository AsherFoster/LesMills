//
//  LesMillsClient.swift
//  LesMills
//
//  Created by Asher Foster on 26/10/23.
//

import Foundation
import Get

struct UserContactDetails: Codable {
    // Core info
    let lesMillsID: Int // 12345678
    let apiToken: UUID // "9a342872-bd11-4e07-b560-1c831f1870a8"
    let homeClubGuid: String // "04"
    let homeClubName: String // "Taranaki Street"
    // Not sure what these represent
//    let contactID: Int // 123456
//    let crmGuid: UUID // "b6bc3912-5d9b-4b59-82ea-ce0e072507a8"
    
    // Personal info
    let firstName: String // "Asher"
    let lastName: String // "Foster"
    let dateOfBirth: String // "1970-01-01T00:00:00"
    let email: String // "example@gmail.com"
    let mobilePhone: String // "0211234567"
    let addressLine1: String // "123 Taranaki Street"
    let addressSuburb: String // "Te Aro"
    let addressCity: String // "Te Aro"
    let addressCountry: String // "Wellington"
    let addressPostcode: String // "6011"
    let emergencyContactName: String // "Josh"
    let emergencyContactPhone: String // "0211234567"
    
    // Preferences
    let sendMarketingEmails: Bool // false
    let sendPushNotifications: Bool // false
    let sendClassReminders: Bool // false
    let saveClassesToCalendar: Bool // true
 
    // Appearingly unused fields
//    let portalPhoto: String? // nil
//    let deviceID: String? // nil
//    let hwid: String? // nil
//    let defaultLandingPage: String? // nil
//    let allowCovidEntry: Bool // false
//    let covidPassExpiryDate: String? // nil
    
    static func mock() -> UserContactDetails {
        UserContactDetails(
            lesMillsID: 12345678,
            apiToken: UUID(),
            homeClubGuid: "04",
            homeClubName: "Taranaki Street",
            firstName: "Asher",
            lastName: "Foster",
            dateOfBirth: "1970-01-01T00:00:00",
            email: "example@gmail.com",
            mobilePhone: "0211234567",
            addressLine1: "123 Taranaki Street",
            addressSuburb: "Te Aro",
            addressCity: "Te Aro",
            addressCountry: "Wellington",
            addressPostcode: "6011",
            emergencyContactName: "Josh",
            emergencyContactPhone: "0211234567",
            sendMarketingEmails: false,
            sendPushNotifications: false,
            sendClassReminders: false,
            saveClassesToCalendar: true
        )
    }
}

enum LesMillsError: Error {
    case notLoggededIn
}

protocol AnonymousLesMillsClient {
    var isAuthenticated: Bool { get }
    
    func tryResumeSession() async -> Bool
    
    // POST /User/SignIn
    // { lesMillsID: String, password: String }
    func login(memberId: String, password: String) async throws -> Bool
    
    // POST /User/ForgotPasswordSendEmail
    // { id: String }
    func forgotPassword(emailOrId: String) async -> Void
}

protocol AuthenticatedLesMillsClient {
    var isAuthenticated: Bool { get }
    
    // POST /User/ValidateAPIToken (auth'd)
    func validateAPIToken() async
    
    func getUserContactDetails() async throws -> UserContactDetails
    
    // POST /User/ChangePassword (auth'd)
    // { currentPassword: String, newPassword: String}
    func changePassword(currentPassword: String, newPassword: String) async -> Void
}

typealias LesMillsClientProtocol = AnonymousLesMillsClient & AuthenticatedLesMillsClient


class LesMillsHTTPClient: LesMillsClient {
    
    private var apiToken: UUID? = nil
    
    var isAuthenticated: Bool {
        apiToken != nil
    }
    
    func tryResumeSession() async -> Bool {
        // TODO retrieve API key from storage
        apiToken = UUID()
        return true
    }
    
    struct LoginResponse: Codable {
        let contactDetails: UserContactDetails
        //    let message: String
        
        static func mock() -> LoginResponse {
            LoginResponse(contactDetails: .mock())
        }
    }
    func login(memberId: String, password: String) async throws -> Bool {
        let response = LoginResponse.mock()
        try await Task.sleep(nanoseconds: 2 * 1000 * 1000 * 1000)
        apiToken = response.contactDetails.apiToken
        return true
    }
    
    func forgotPassword(emailOrId: String) -> Void {}
    
    func validateAPIToken() {}
    
    struct GetDetailsResponse: Codable {
        let contactDetails: UserContactDetails
        
        static func mock() -> GetDetailsResponse {
            GetDetailsResponse(contactDetails: .mock())
        }
    }
    func getUserContactDetails() async throws -> UserContactDetails {
        guard isAuthenticated else {
            throw LesMillsError.notLoggededIn
        }
        // GET /User/GetDetails
        // Auth'd
        return .mock()
    }
    
    func changePassword(currentPassword: String, newPassword: String) {}
}


class MockLesMillsClient: LesMillsClient {
    var isAuthenticated: Bool {
        true
    }
    
    func tryResumeSession() -> Bool {
        true
    }
    
    func login(memberId: String, password: String) -> Bool {
        true
    }
    
    func forgotPassword(emailOrId: String) {
        
    }
    
    func validateAPIToken() {
        
    }
    
    func getUserContactDetails() -> UserContactDetails {
        .mock()
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
        
    }
    
}


final class LesMillsClient {
    static let apiBase = URL(string: "https://appservices.lesmills.co.nz/1.6")!
    private var _apiClient: APIClient
    
    init(apiToken: String?) {
        self._apiClient = APIClient(baseURL: LesMillsClient.apiBase) { configuration in
            configuration.delegate = self
            
//            configuration.sessionConfiguration = sessionConfiguration
//            configuration.sessionDelegate = sessionDelegate
//
//            let isoDateFormatter: DateFormatter = OpenISO8601DateFormatter()
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .formatted(isoDateFormatter)
//            configuration.decoder = decoder
//
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .formatted(isoDateFormatter)
//            encoder.outputFormatting = .prettyPrinted
//            configuration.encoder = encoder
        }
    }
}

extension LesMillsClient: APIClientDelegate {
    
}

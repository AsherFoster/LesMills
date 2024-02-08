import Foundation
import Get

struct UpdateDetailsRequest: Codable, Hashable {
    let email: String? // "example@gmail.com"
    let mobilePhone: String? // "0211234567"
    
    let addressLine1: String? // "123 Taranaki Street"
    let addressSuburb: String? // "Te Aro"
    let addressCity: String? // "Te Aro"
    let addressCountry: String? // "Wellington"
    let addressPostcode: String? // "6011"
    
    let emergencyContactName: String? // "Josh"
    let emergencyContactPhone: String? // "0211234567"
//    let defaultLandingPage: String // not relevant
    
    // Preferences
    let sendMarketingEmails: Bool? // false
    let sendPushNotifications: Bool? // false
    let sendClassReminders: Bool? // false
    let saveClassesToCalendar: Bool? // true
}

struct UpdateDetailsResponse: Codable, Hashable {
    let message: String
}

extension Paths {
    /// Update any changed fields on the user's profile. Omitted = unchanged
    static func updateDetails(changes: UpdateDetailsRequest) -> Request<UpdateDetailsResponse> {
        Request(path: "/User/UpdateDetails", method: "POST", body: changes, id: "UpdateDetails")
    }
}

import Foundation

struct UserContactDetails: Codable, Hashable {
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

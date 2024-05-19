import Foundation
import Factory

struct UserProfileDraft {
    private var profile: UserProfile
    
    var email: String // "example@gmail.com"
    var mobilePhone: String // "0211234567"
    var addressLine1: String // "123 Taranaki Street"
    var addressSuburb: String // "Te Aro"
    var addressCity: String // "Te Aro"
    var addressCountry: String // "Wellington"
    var addressPostcode: String // "6011"
    var emergencyContactName: String // "Josh"
    var emergencyContactPhone: String // "0211234567"
    
    // Preferences
    var sendMarketingEmails: Bool // false
    var sendPushNotifications: Bool // false
    var sendClassReminders: Bool // false
    var saveClassesToCalendar: Bool // true
    
    init(profile: UserProfile) {
        self.profile = profile
        email = profile.email
        mobilePhone = profile.mobilePhone
        addressLine1 = profile.addressLine1
        addressSuburb = profile.addressSuburb
        addressCity = profile.addressCity
        addressCountry = profile.addressCountry
        addressPostcode = profile.addressPostcode
        emergencyContactName = profile.emergencyContactName
        emergencyContactPhone = profile.emergencyContactPhone
        sendMarketingEmails = profile.sendMarketingEmails
        sendPushNotifications = profile.sendPushNotifications
        sendClassReminders = profile.sendClassReminders
        saveClassesToCalendar = profile.saveClassesToCalendar
    }
    
    func getUpdate() -> UpdateDetailsRequest {
        // This is a crime. Surely there's a better way to do this that's still typed?
        return UpdateDetailsRequest(
             email: email != profile.email ? email : nil,
             mobilePhone: mobilePhone != profile.mobilePhone ? mobilePhone : nil,
             addressLine1: addressLine1 != profile.addressLine1 ? addressLine1 : nil,
             addressSuburb: addressSuburb != profile.addressSuburb ? addressSuburb : nil,
             addressCity: addressCity != profile.addressCity ? addressCity : nil,
             addressCountry: addressCountry != profile.addressCountry ? addressCountry : nil,
             addressPostcode: addressPostcode != profile.addressPostcode ? addressPostcode : nil,
             emergencyContactName: emergencyContactName != profile.emergencyContactName ? emergencyContactName : nil,
             emergencyContactPhone: emergencyContactPhone != profile.emergencyContactPhone ? emergencyContactPhone : nil,
             sendMarketingEmails: sendMarketingEmails != profile.sendMarketingEmails ? sendMarketingEmails : nil,
             sendPushNotifications: sendPushNotifications != profile.sendPushNotifications ? sendPushNotifications : nil,
             sendClassReminders: sendClassReminders != profile.sendClassReminders ? sendClassReminders : nil,
             saveClassesToCalendar: saveClassesToCalendar != profile.saveClassesToCalendar ? saveClassesToCalendar : nil
         )
    }
}

class AccountViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient
    
    @Published var isLoading = false
    @Published var profile: UserProfile
    var draftProfile: UserProfileDraft? = nil
    
    init(profile: UserProfile) {
        self.profile = profile
        draftProfile = .init(profile: profile)
    }
    
    func saveDraftProfile() async throws {
        guard let draftProfile = draftProfile else { return }
        
        let request = Paths.updateDetails(changes: draftProfile.getUpdate())
        _ = try await client.send(request)
        
        let updateProfileRequest = Paths.getDetails()
        let contactDetails = try await client.send(updateProfileRequest).value.contactDetails
        
        await MainActor.run {
            profile = contactDetails
            self.draftProfile = .init(profile: contactDetails)
        }
    }
    
    static func mock() -> AccountViewModel {
        AccountViewModel(profile: .mock())
    }
}

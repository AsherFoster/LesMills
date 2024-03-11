import Foundation

struct Club: Codable, Hashable, Identifiable {
    let id: String // "01"
    let name: String // "Auckland City"

//    let openingHours: String // "<table>...</table><p>All workout areas close half an hour before closing time</p>" TODO parse this
//    let description: String // "<p>Les Mills Auckland City is our flagship club...</p>" TODO parse this
    
//    let location: String // "-36.84816,174.75567"  TODO parse this
    let streetAddress: String // "186 Victoria Street, Auckland Central"
    
    let phoneNumber: String // "09 123 4567"
    let emailAddress: String // "example@lesmills.co.nz"
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "nodeName"
        case streetAddress = "streetAddress"
        case phoneNumber = "phoneNumber"
        case emailAddress = "emailAddress"
    }
    
    static func mock() -> Club {
        Club(
            id: "01",
            name: "Auckland City",
//            location: "-36.84816,174.75567",
//            description: "<p>Les Mills Auckland City is our flagship club, a haven for fitness fans from New Zealand and around the globe since opening in 1968.</p>",
            streetAddress: "186 Victoria Street, Auckland Central",
            phoneNumber: "09 123 4567",
            emailAddress: "example@lesmills.co.nz"
        )
    }
}

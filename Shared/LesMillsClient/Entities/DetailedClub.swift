import Foundation

struct DetailedClub: Codable, Hashable, Identifiable {
    let id: String // "01"
    let nodeName: String // "Auckland City"
//    let urlName: String // "Auckland City"
    let location: String // "-36.84816,174.75567"
    // rendering this is gonna suck:
//    let openingHours: String // "<table>...</table><p>All workout areas close half an hour before closing time</p>"
    let description: String // "<p>Les Mills Auckland City is our flagship club...</p>"
    let streetAddress: String // "186 Victoria Street, Auckland Central"
    let phoneNumber: String // "09 123 4567"
    let emailAddress: String // "example@lesmills.co.nz"
//    let crmClub: String // "01"
//    let crmClubLocation: String // "-36.84816,174.75567"
//    let crmClubDataArea: String // "AX2009"
//    let posClubTerminalID: Int // 888
//    let posClubStartSaleNumber: String // "1"
//    let posClubEndSaleNumber: String // "999999999"
//    let accountingClubId: String // "01"
//    let clubManagerEmail: String // "example@lesmills.co.nz"
    
    static func mock() -> DetailedClub {
        DetailedClub(
            id: "01",
            nodeName: "Auckland City",
            location: "-36.84816,174.75567",
            description: "<p>Les Mills Auckland City is our flagship club, a haven for fitness fans from New Zealand and around the globe since opening in 1968.</p>",
            streetAddress: "186 Victoria Street, Auckland Central",
            phoneNumber: "09 123 4567",
            emailAddress: "example@lesmills.co.nz"
        )
    }
}

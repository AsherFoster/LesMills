import Foundation
import Get

struct RemoveBookingRequest: Codable, Hashable {
    let classID: UUID
    let clubServiceID: String
}

struct RemoveBookingDetail: Codable, Hashable {
//    let classBookingID: Int // 11472956
//    let contactID: Int // 123456
//    let crmClassID: UUID // 4a8e2a47-c4a9-ee11-be37-000d3a79bb55
//    let clubGuid: UUID // 00000000-0000-0000-0000-000000000000
//    let lmServiceID: UUID // 4a8e2a47-c4a9-ee11-be37-000d3a79bb55
    let clubServiceID: UUID // 4a8e2a47-c4a9-ee11-be37-000d3a79bb55
//    let purchasedProductID: UUID? // null
//    let crmBookingID: UUID // 5776a91e-1fb3-ee11-a568-000d3ae1adab
//    let name: String // Ceremony??|1\/18\/2024 6:15:00 PM|0
    let status: String // UnbookedInCRM
//    let creditValue: String? // null
//    let noCostCancellationHours: Int // 0
//    let crmBookingDate: String // 2024-01-15T09:54:41.563
//    let whenBooked: String // 2024-01-15T09:54:41.57
//    let whenCancelled: String // 2024-01-15T09:54:44.3643921+13:00
//    let whenClassDetailsModified: String? // null
//    let clubCode: String? // null
}

struct RemoveBookingResponse: Codable, Hashable {
//    let failedBooking: [RemoveBookingDetail]
//    let failedBookings: [RemoveBookingDetail]
    let removedBookings: [RemoveBookingDetail]
}

extension Paths {
    
    /// It's slightly unclear to me what the difference between this and saveBooking is.
    ///
    static func removeBooking(classSession: ClassSession) -> Request<RemoveBookingResponse> {
        Request(
            path: "/Booking/RemoveBooking",
            method: "POST",
            body: RemoveBookingRequest(
                classID: classSession.id,
                clubServiceID: classSession.clubServiceName
            ),
            id: "RemoveBooking"
        )
    }
}

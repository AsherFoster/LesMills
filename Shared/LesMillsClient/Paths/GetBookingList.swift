import Foundation
import Get

struct GetBookingListResponse: Codable, Hashable {
    let success: Bool
    let error: String
    let scheduleClassBooking: [APIClassSession]
}

extension Paths {
    static func getBookingList() -> Request<GetBookingListResponse> {
        Request(path: "/Booking/GetScheduleClassBookingList", method: "GET", id: "GetBookingList")
    }
}

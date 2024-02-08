import Get
import Foundation

struct PrepareBookingRequest: Codable, Hashable {
    let classID: UUID
    let clubID: String
    let clubServiceID: String
    let name: String
    
    // Booking succeeds without it but it might accidentally bypass class limits
    let availableSpaces: Int
    let maxCapacity: Int
    let dateAndTime: String
}

extension Paths {
    
    /// It's slightly unclear to me what the difference between this and saveBooking is.
    ///
    static func prepareBooking(session: ClassSession) -> Request<SaveBookingResponse> {
        Request(
            path: "/Booking/PrepareBooking",
            method: "POST",
            body: PrepareBookingRequest(
                classID: session.id,
                clubID: session.club.id,
                clubServiceID: session.clubServiceId,
                name: session.name,
                availableSpaces: session.maxCapacity - session.spacesTaken,
                maxCapacity: session.maxCapacity,
                dateAndTime: CommonDateFormats.nzISODateTime.string(from: session.startsAt)
            ),
            id: "PrepareBooking"
        )
    }
}

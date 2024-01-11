//
//  SaveBooking.swift
//  LesMills
//
//  Created by Asher Foster on 11/01/24.
//
import Get
import Foundation

struct SaveBookingRequest: Codable, Hashable {
    let classID: UUID
    let clubID: String
    let clubServiceID: String
    let name: String
}

struct SaveBookingResponse: Codable, Hashable {
    let message: SaveBookingResponseMessage
    
    struct SaveBookingResponseMessage: Codable, Hashable {
        // AddToScheduleSingleSuccess
        // AddToScheduleSingleFail - if clubServiceID is missing
        // ClassAlreadyBooked
        // ClassIsFull - returned from PrepareBooking
        let addBookingResult: String
//        let className: String
//        let classDateTime: String // garbage
//        let penaltyEndDate: String?
//        let status: Int
//        let memberCreditsToBeUsed: Int?
    }
}

extension Paths {
    
    /// It's slightly unclear to me what the difference between this and prepareBooking is. This endpoint appears to be used when a booking isn't needed (no space limit)
    /// Fun quirks include:
    ///  - The official app sends a whole host of data, but only these fields appear to be required
    ///  - The API will echo back to you whatever you provide as name, going as far as returning it from `/Booking/GetClassBookingList`
    ///  - `classID` doesn't actually appear to be required, you can create your own classes
    static func saveBooking(classSession: ClassSession) -> Request<SaveBookingResponse> {
        Request(
            path: "/Booking/SaveBooking",
            method: "POST",
            body: SaveBookingRequest(
                classID: classSession.id,
                clubID: classSession.club.id,
                clubServiceID: classSession.clubServiceName,
                name: classSession.name
            ),
            id: "SaveBooking"
        )
    }
}

//
//  PrepareBooking.swift
//  LesMills
//
//  Created by Asher Foster on 11/01/24.
//
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
    static func prepareBooking(classSession: ClassSession) -> Request<SaveBookingResponse> {
        Request(
            path: "/Booking/PrepareBooking",
            method: "POST",
            body: PrepareBookingRequest(
                classID: classSession.id,
                clubID: classSession.club.id,
                clubServiceID: classSession.clubServiceName,
                name: classSession.name
            ),
            id: "SaveBooking"
        )
    }
}

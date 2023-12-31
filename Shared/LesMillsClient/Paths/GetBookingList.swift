//
//  GetBookingList.swift
//  LesMills
//
//  Created by Asher Foster on 26/12/23.
//

import Foundation
import Get

struct GetBookingListResponse: Codable, Hashable {
    let success: Bool
    let error: String
    let scheduleClassBooking: [ClassSession]
}

extension Paths {
    static func getBookingList() -> Request<GetBookingListResponse> {
        Request(path: "/Booking/GetScheduleClassBookingList", method: "GET", id: "GetBookingList")
    }
}

//
//  GetTimetable.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Foundation
import Get

struct GetTimetableRequest: Codable, Hashable {
    let clubId: String
    
    public var asQuery: [(String, String?)] {
        return [
            ("clubId", clubId)
        ]
    }
}

struct GetTimetableDay: Codable, Hashable {
    let dayName: String
    let date: String
}

// a dumb data structure deserves a dumb name
struct GetTimetableTimeOfDayOfTimeOfDay: Codable, Hashable {
    let date: String // 2023-12-12T06:00:00
    let classes: [ClassInstance]
}

struct GetTimetableTime: Codable, Hashable {
    let time: String // "06:00:00"
    let days: [GetTimetableTimeOfDayOfTimeOfDay]
}

struct GetTimetableTimeOfDay: Codable, Hashable {
    let name: String // "Morning"
    let times: [GetTimetableTime]
}

struct GetTimetableResponse: Codable, Hashable {
    let days: [GetTimetableDay]
    let timesOfDay: [GetTimetableTimeOfDay]
    
    func flatList() -> [ClassInstance] {
        var classes: [ClassInstance] = []
        for timeOfDate in self.timesOfDay {
            for t in timeOfDate.times {
                classes += t.days.flatMap { $0.classes }
            }
        }
        return classes
    }
}

struct NormalisedTimetable {
    private let classes: [ClassInstance]
    
    public var dates: [DateComponents] {
        let calendar = Calendar.current
        var datesSet = Set<DateComponents>()
        return classes
            .map {
                calendar.dateComponents([.year, .month, .day], from: $0.startsAt)
            }
            .filter { datesSet.insert($0).inserted }
    }
    
    public func classesForDate(date: DateComponents) -> [ClassInstance] {
        let calendar = Calendar.current
        return classes.filter { calendar.dateComponents([.year, .month, .day], from: $0.startsAt) == date }
    }
    
    init(responses: [GetTimetableResponse]) {
        var classes: [ClassInstance] = responses.flatMap { $0.flatList() }
        
        // Combining the two timetables together will get them out of order
        classes.sort(by: { $0.startsAt < $1.startsAt })
        
        self.classes = classes
    }
}

extension Paths {
    /// Get a list of all instructors that run classes at a set of clubs (name only)
    static func getTimetable(club: ClubDetailPage) -> Request<GetTimetableResponse> {
        Request(
            path: "/LesMillsData/GetTimetable",
            method: "GET",
            query: GetTimetableRequest(clubId: club.id).asQuery,
            id: "GetTimetable"
        )
    }
}


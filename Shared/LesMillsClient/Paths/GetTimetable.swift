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

struct GetTimetableResponse: Codable, Hashable {
    let days: [GetTimetableDay]
    struct GetTimetableDay: Codable, Hashable {
        let dayName: String
        let date: String
    }
    
    let timesOfDay: [GetTimetableTimeOfDay]
    struct GetTimetableTimeOfDay: Codable, Hashable {
        let name: String // "Morning"
        let times: [GetTimetableTime]
        
        struct GetTimetableTime: Codable, Hashable {
            let time: String // "06:00:00"
            let days: [GetTimetableTimeOfDayOfTimeOfDay]
            
            // a dumb data structure deserves a dumb name
            struct GetTimetableTimeOfDayOfTimeOfDay: Codable, Hashable {
                let date: String // 2023-12-12T06:00:00
                let classes: [APIClassSession]
            }
        }
    }
    
    var sessions: [APIClassSession] {
        // This data structure is insane
        timesOfDay.flatMap { $0.times.flatMap { $0.days.flatMap { $0.classes }}}
    }
}


extension Paths {
    /// Get a list of all instructors that run classes at a set of clubs (name only)
    static func getTimetable(club: Club) -> Request<GetTimetableResponse> {
        Request(
            path: "/LesMillsData/GetTimetable",
            method: "GET",
            query: GetTimetableRequest(clubId: club.id).asQuery,
            id: "GetTimetable"
        )
    }
}


//
//  NormalisedTimetable.swift
//  LesMills
//
//  Created by Asher Foster on 14/12/23.
//

import Foundation

struct NormalisedTimetable {
    private let classes: [ClassInstance]
    
    public var dates: [Date] {
        let calendar = Calendar.current
        var datesSet = Set<Date>()
        return classes
            .map {
                calendar.startOfDay(for: $0.startsAt)
            }
            // Don't return the set in order to maintain list order
            .filter { datesSet.insert($0).inserted }
    }
    
    public func classesForDate(date: Date) -> [ClassInstance] {
        let calendar = Calendar.current
        assert(calendar.startOfDay(for: date) == date)
        
        return classes.filter { calendar.isDate($0.startsAt, equalTo: date, toGranularity: .day) }
    }
    
    init(responses: [GetTimetableResponse]) {
        var classes: [ClassInstance] = responses.flatMap { $0.flatList }
        
        // Combining the two timetables together will get them out of order
        classes.sort(by: { $0.startsAt < $1.startsAt })
        
        self.classes = classes
    }
}

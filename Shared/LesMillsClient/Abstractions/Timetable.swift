import Foundation

struct Timetable {
    public let classes: [ClassSession]
    
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
    
    public func classesForDate(date: Date) -> [ClassSession] {
        let calendar = Calendar.current
        assert(calendar.startOfDay(for: date) == date)
        
        return classes.filter { calendar.isDate($0.startsAt, equalTo: date, toGranularity: .day) }
    }
    
    private init(classes: [ClassSession]) {
        self.classes = classes
    }
    
    static func mock() -> Timetable {
        Timetable(classes: [.mock(), .mock()])
    }
}

extension Timetable {
    /// Hydrate APIClassTypes with full club and classType data
    init(responses: [GetTimetableResponse], classTypes: [ClassType], clubs: [Club]) {
        var classes = responses
            .flatMap { $0.sessions }
            .map { $0.toClassSession(clubs: clubs, classTypes: classTypes) }
        
        // Combining the two timetables together will get them out of order
        classes.sort(by: { $0.startsAt < $1.startsAt })
        
        self.classes = classes
    }    
}

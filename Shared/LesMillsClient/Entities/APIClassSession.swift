import Foundation

/// This struct was generated from the LesMillsData/GetTimetable API endpoint
///
/// Various Les Mills endpoints have frustrating inconsistencies, so it's helpful to have an abstraction layer beyond the data they return
/// Instead, prefer using ClassSession
struct APIClassSession: Codable, Hashable, Identifiable {
    let id: UUID // Example: "0c920d5b-8110-ee11-8f6d-000d3a79b82b"
    let club: BasicClub
    struct BasicClub: Codable, Hashable, Identifiable {
        let id: String // Example: "04"
        let name: String // Example: "Taranaki Street"
    }

    let lesMillsServiceId: String // Example: "900" (aka crmClassCode)
    let clubServiceId: String // Example: "04|900|"
    let instructor: DetailedInstructor
    struct DetailedInstructor: Codable, Hashable, Identifiable {
        let id: UUID // Example: "3cbddc6a-8685-e811-a95e-000d3ae12152"
        let name: String // Example: "Bex Palmer"
        let firstName: String // Example: "Bex Palmer"
    }
//    let clubServiceName: String // Example: "CEREMONY"
    let classLocation: String // Example: "Studio 2"
    let name: String // Example: "CEREMONY"
    let description: String? // Null in example provided
    let durationHours: Double // Example: 0.75
    
    private let dateTime: String // Example: "2023-09-13T06:00:00"
    var startsAt: Date {
        if let date = CommonDateFormats.nzISODateTime.date(from: dateTime) {
            return date
        }
        
        // Wait, this tries using two different date formats?
        // Yup! The `/Booking/GetScheduleClassBookingList` and `/LesMillsData/GetTimetable` return the same
        // shape of data - this ClassSession struct. Except one endpoint includes a timezone in dateTime and
        // one does! Seems insane, right?
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        guard let date = dateFormatter.date(from: dateTime) else {
            fatalError("Invalid date format")
        }

        return date
    }
    
    let allowBookings: Bool // Example: true
//    let allowWaitList: Bool // Example: false
//    let childrensClass: Bool // Example: false
//    let maxAge: Int // Example: 0
//    let minAge: Int // Example: 0
//    let noCostCancellationHours: Int // Example: 0 (always 0)
    let maxCapacity: Int // Example: 48
    let spacesTaken: Int // Example: 40
    //let bookingLink: String? // Null in example provided
//    let isFisikalService: Bool // Example: false
    let cmsColour: String // Example: "#CCCCCC"
    
    
//    let cmsName: String // Example: "CEREMONY"
//    let cmsUrlName: String? // Null in example provided
//    let classUrl: String? // Example: "https://www.lesmills.co.nz/group-fitness/classes/ceremony"
//    let popularClass: Bool // Example: false (haven't seen this used)
    let popularClassText: String // Example: ""
}

extension APIClassSession {
    func toClassSession(clubs: [Club], classTypes: [ClassType]) -> ClassSession {
        let maybeClub = clubs.first { $0.id == self.club.id }
        let club = maybeClub ?? Club(
            id: "ERROR",
            name: "ERROR",
            streetAddress: "ERROR",
            phoneNumber: "ERROR",
            emailAddress: "ERROR"
        )
        return toClassSession(
            club: club,
            classType: classTypes.first { $0.contains(apiID: lesMillsServiceId) }
        )
    }
    
    func toClassSession(club: Club, classType: ClassType?) -> ClassSession {
        ClassSession(
            id: id,
            name: ClassType.getCleanedName(name),
            club: club,
            classType: classType,
            location: classLocation,
            instructor: instructor.name,
            startsAt: startsAt,
            duration: Measurement(value: durationHours, unit: .hours),
            apiID: lesMillsServiceId,
            apiType: name,
            requiresBooking: allowBookings,
            maxCapacity: maxCapacity,
            spacesTaken: spacesTaken,
            colourHex: cmsColour,
            popularReason: popularClassText
        )
    }
}

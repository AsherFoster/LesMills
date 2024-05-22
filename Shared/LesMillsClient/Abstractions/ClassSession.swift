import Foundation

struct ClassSession: Hashable, Identifiable {
    let id: UUID // Example: "0c920d5b-8110-ee11-8f6d-000d3a79b82b"
    let name: String // Normalised version of apiType
    let club: Club
    let classType: ClassType?
    
    let location: String // Example: "Studio 2"
    let instructor: String
    
    let startsAt: Date
    let duration: Measurement<UnitDuration>
    
    let apiID: String
    let apiType: String
    let requiresBooking: Bool
    let maxCapacity: Int // Example: 48
    let spacesTaken: Int // Example: 40
    
    let colourHex: String
    let popularReason: String?
}

// MARK: booking
extension ClassSession {
    enum SessionAvailability {
        case available
        case sessionInPast
        case sessionIsFull
    }
    static let bookingMinimumNotice = TimeInterval(5 * 60)
    
    var availability: SessionAvailability {
        if startsAt.addingTimeInterval(ClassSession.bookingMinimumNotice) < Date.now {
            return .sessionInPast
        }
        if spacesTaken >= maxCapacity {
            return .sessionIsFull
        }
        return .available
    }
}

// MARK: mock
extension ClassSession {
    static func mock(isInPast: Bool = false) -> ClassSession {
        let mockClass = ClassType.MockClassInstance.mocks.randomElement()!
        
        var location: String {
            if ["Sprint", "The Trip"].contains(mockClass.name) {
                return "Cycle Studio"
            } else {
                return ["Studio 1", "Studio 2"].randomElement()!
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This is a crime
        dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")
        
        let club = Club.mock()
        let serviceId = String(Int.random(in: 1...99))
        
        return ClassSession(
            id: UUID(),
            name: mockClass.name,
            club: club,
            
            classType: ClassType(
                genericName: mockClass.name,
                description: "Total body workout to gain strength and lean, toned muscle.",
                websiteUrl: URL(string: "https://www.lesmills.co.nz/group-fitness/classes/bodypump"),
                apiTypes: [mockClass.name],
                apiIDs: [serviceId]
            ),
            
            location: location,
            instructor: ["Adrian Marsden", "Cleo Bennett", "Dalton Frazier", "Erika Hutton", "Fiona Greenway"].randomElement()!,
            
            startsAt: Calendar.current.date(byAdding: .hour, value: isInPast ? -1 : 1, to: .now)!,
            duration: Measurement(value: Double(mockClass.duration), unit: UnitDuration.minutes),
            
            apiID: serviceId,
            apiType: mockClass.name,
            requiresBooking: true,
            maxCapacity: 40,
            spacesTaken: 3,
            
            colourHex: mockClass.color,
            popularReason: nil
        )
    }
}

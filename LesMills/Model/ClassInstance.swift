//
//  ClassInstance.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import Foundation
import SwiftUI

struct Club: Codable, Identifiable {
    let id: String // Example: "04"
    let name: String // Example: "Taranaki Street"
    
    static func mock() -> Club {
        Club(id: "04", name: "Taranaki Street")
    }
}

struct Instructor: Codable, Identifiable {
    let id: UUID // Example: "3cbddc6a-8685-e811-a95e-000d3ae12152"
    let name: String // Example: "Bex Palmer"
    let firstName: String // Example: "Bex Palmer"
    
    static func mock() -> Instructor {
        let name = ["Adrian Marsden", "Cleo Bennett", "Dalton Frazier", "Erika Hutton", "Fiona Greenway"].randomElement()!
        return Instructor(id: UUID(), name: name, firstName: name)
    }
}

// This struct was generated from the LesMillsData/GetTimetable API endpoint
struct ClassInstance: Codable, Identifiable {
    let id: UUID // Example: "0c920d5b-8110-ee11-8f6d-000d3a79b82b"
    let club: Club
    let lesMillsServiceId: String // Example: "900" (aka crmClassCode)
//    let clubServiceId: String // Example: "04|900|"
    let instructor: Instructor
    let clubServiceName: String // Example: "CEREMONY"
    let classLocation: String // Example: "Studio 2"
    let name: String // Example: "CEREMONY"
    let description: String? // Null in example provided
    let durationHours: Double // Example: 0.75
    var durationMinutes: Int {
        Int(durationHours * 60)
    }
    
    private let dateTime: String // Example: "2023-09-13T06:00:00"
    var startsAt: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // This is a crime
        dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")

        return dateFormatter.date(from: dateTime)!
    }
    
    let allowBookings: Bool // Example: true
    let allowWaitList: Bool // Example: false
    let childrensClass: Bool // Example: false
    let maxAge: Int // Example: 0
    let minAge: Int // Example: 0
//    let noCostCancellationHours: Int // Example: 0 (always 0)
    let maxCapacity: Int // Example: 48
    let spacesTaken: Int // Example: 40
    //let bookingLink: String? // Null in example provided
    let isFisikalService: Bool // Example: false
    private let cmsColour: String // Example: "#CCCCCC"
    private static let defaultColor = Color.red
    var color: Color {
        guard let rgb = Int(cmsColour.dropFirst(1), radix: 16) else {
            return ClassInstance.defaultColor
        }
        
        return Color(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
    
    let cmsName: String // Example: "CEREMONY"
    //let cmsUrlName: String? // Null in example provided
    let classUrl: String? // Example: "https://www.lesmills.co.nz/group-fitness/classes/ceremony"
//    let popularClass: Bool // Example: false (haven't seen this used)
//    let popularClassText: String // Example: ""
    
    
    struct MockClassInstance {
        let name: String
        let duration: Int
        let color: String
        
        static let mocks: [MockClassInstance] = [
            MockClassInstance(name: "BodyAttack 45", duration: 45, color: "#FEC424"),
            MockClassInstance(name: "BodyBalance 45", duration: 45, color: "#C5E86C"),
            MockClassInstance(name: "BodyCombat 45", duration: 45, color: "#787121"),
            MockClassInstance(name: "BodyPump 45", duration: 45, color: "#FE0000"),
            MockClassInstance(name: "BodyPump", duration: 60, color: "#FE0000"),
            MockClassInstance(name: "CEREMONY", duration: 45, color: "#CCCCCC"),
            MockClassInstance(name: "Sprint", duration: 30, color: "#D2BE57"),
            MockClassInstance(name: "The Trip", duration: 40, color: "#000000"),
            MockClassInstance(name: "GRIT Strength", duration: 30, color: "#000000"),
            MockClassInstance(name: "GRIT Cardio", duration: 30, color: "#000000"),
            MockClassInstance(name: "BodyJam", duration: 60, color: "#FCF710"),
            MockClassInstance(name: "Barre", duration: 60, color: "#F09787")
        ]
        var location: String {
            if ["Sprint", "The Trip"].contains(name) {
                return "Cycle Studio"
            } else {
                return ["Studio 1", "Studio 2"].randomElement()!
            }
        }
    }
    
    
    static func mock() -> ClassInstance {
        let mockClass = MockClassInstance.mocks.randomElement()!
        
        return ClassInstance(
            id: UUID(),
            club: Club.mock(),
            lesMillsServiceId: String(Int.random(in: 1...99)),
            instructor: Instructor.mock(),
            clubServiceName: mockClass.name,
            classLocation: mockClass.location,
            name: mockClass.name,
            description: nil,
            durationHours: Double(mockClass.duration) / 60.0,
            dateTime: "2023-09-20T16:30:00",
            allowBookings: true,
            allowWaitList: false,
            childrensClass: false,
            maxAge: 0,
            minAge: 0,
            maxCapacity: 40,
            spacesTaken: 3,
            isFisikalService: false,
            cmsColour: mockClass.color,
            cmsName: mockClass.name,
            classUrl: "https://www.lesmills.co.nz/group-fitness/classes/the-trip"
        )
    }
}

// This struct was generated based on the TimetablePage/GetTimetableCards endpoint.
// Fields that appear unused or bad practice are commented out - it's entirely possible that these are used outside of the limited dataset I used though.
struct WebsiteClassInstance: Codable, Identifiable {
    var id: String {
        crmClassInstanceID
    }
    
    // let tag: String? // Always null
    // let clubID: Int // Always 0
    let crmClubCode: String // Example: "04"
    let clubName: String // Example: "Taranaki Street"
    // let timetableClassID: Int // Always 0
    // let fullClassName: String? // Always null
    let crmClassCode: String // Example: "96"
    let className: String // Example: "Virtual BodyPump 45"
    let introduction: String? // Example: "30-minute High-Intensity Interval Training using a step and weight plates"
    let classUrl: String // Example: "https://www.lesmills.co.nz/group-fitness/classes/bodypump"
    let siteName: String // Example: "Studio 2"
    // let siteCapacity: Int // Always 0
    
    // We're a real app and should handle date formatting ourselves
    private let startDate: String // Example: "01 Oct 2023"
    private let startTime: String // Example: "14:00"
    // let displayStartTime: String // Example: " 2:00 PM"
    // private let startDateTime: String // Example: "01 Oct 2023 02:00" - this field isn't machine readable, it's 12 hour time without am/pm
    
    var startsAt: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Pacific/Auckland")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.date(from: "\(startDate) \(startTime)")!
    }
    // let endDateTime: String? // Always null
    
    let durationMins: Int // Example: 45
    let intensity: Int // Example: 5 (range: 1 - 5)
    // let allowBooking: Bool // Always false
    // let availableSpaces: Int // Always 0
    let mainInstructorName: String // Example: "Virtual Trainer"
    let secondaryInstructorName: String // Example: ""
    // let isPublished: Bool // Always false
    // let popularClass: Bool // Always false
    let popularClassText: String // Example: "Available until 18 Dec"
    // let popularClassDivider: String // Example: "|"
    // let isStartupClass: Bool // Always false
    // let isVirtualClass: Bool // Always false
    // let status: String? // Always null
    // let crmBookingID: String // Always "00000000-0000-0000-0000-000000000000"
    let crmClassInstanceID: String // Example: "653a22ce-e918-ee11-8f6c-000d3a79b5e8"
    // let crmClassDefinitionID: String? // Always null
    // let crmMainInstructorID: String? // Always null
    // let crmSecondaryInstructorID: String? // Always null
    
    private let colorHexCode: String // Example: "FE0000"
    private static let defaultColor = Color.red
    var color: Color {
        guard let rgb = Int(colorHexCode, radix: 16) else {
            return WebsiteClassInstance.defaultColor
        }
        
        return Color(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
    
    let bookingIcon: String // Example: "" | "add" | "full" | "past"
    let bookingIconTitle: String // Example: "Sorry, no spots left!"
    
    static let mock: WebsiteClassInstance = WebsiteClassInstance(
        crmClubCode: "04",
        clubName: "Taranaki Street",
        crmClassCode: "900",
        className: "CEREMONY",
        introduction: "Functional training, performance, human movement.",
        classUrl: "https://www.lesmills.co.nz/group-fitness/classes/ceremony",
        siteName: "Studio 2",
        startDate: "03 Oct 2023",
        startTime: "16:15",
        durationMins: 45,
        intensity: 5,
        mainInstructorName: "Ash Cameron",
        secondaryInstructorName: "",
        popularClassText: "",
        crmClassInstanceID: "13df130c-7c1a-ee11-8f6c-000d3a79b82b",
        colorHexCode: "CCCCCC",
        bookingIcon: "add",
        bookingIconTitle: "Click to book this session."
    )
}


//
//  ClassInstance.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Foundation
import SwiftUI

struct Club: Codable, Hashable, Identifiable {
    let id: String // Example: "04"
    let name: String // Example: "Taranaki Street"
    
    static func mock() -> Club {
        Club(id: "04", name: "Taranaki Street")
    }
}

struct Instructor: Codable, Hashable, Identifiable {
    let id: UUID // Example: "3cbddc6a-8685-e811-a95e-000d3ae12152"
    let name: String // Example: "Bex Palmer"
    let firstName: String // Example: "Bex Palmer"
    
    static func mock() -> Instructor {
        let name = ["Adrian Marsden", "Cleo Bennett", "Dalton Frazier", "Erika Hutton", "Fiona Greenway"].randomElement()!
        return Instructor(id: UUID(), name: name, firstName: name)
    }
}

// This struct was generated from the LesMillsData/GetTimetable API endpoint
struct ClassInstance: Codable, Hashable, Identifiable {
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
    let cmsColour: String // Example: "#CCCCCC"
    
    
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

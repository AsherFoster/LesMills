//
//  ClassInstance.swift
//  LesMills
//
//  Created by Asher Foster on 30/09/23.
//

import Foundation
import SwiftUI


// This struct was generated based on the TimetablePage/GetTimetableCards endpoint.
// Fields that appear unused or bad practice are commented out - it's entirely possible that these are used outside of the limited dataset I used though.
struct ClassInstance: Codable, Identifiable {
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
            return ClassInstance.defaultColor
        }
        
        return Color(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0
        )
    }
    
    let bookingIcon: String // Example: "" | "add" | "full" | "past"
    let bookingIconTitle: String // Example: "Sorry, no spots left!"
    
    static let mock: ClassInstance = ClassInstance(
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


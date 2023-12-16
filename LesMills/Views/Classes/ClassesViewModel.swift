//
//  ClassesViewModel.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Combine
import Foundation

class ClassesViewModel: ViewModel {
    @Published public var profile: UserContactDetails? = nil
    
    @Published public var allClubs: [DetailedClub] = []
    @Published public private(set) var selectedClubs: Set<DetailedClub> = []
    public func setSelectedClubs(_ newClubs: Set<DetailedClub>) async throws {
        await MainActor.run {
            selectedClubs = newClubs
        }
        try await onClubsChange()
    }
    
    @Published public var allInstructors: [BasicInstructor] = []
    @Published public var selectedInstructors: Set<BasicInstructor> = []
    
    @Published public var allClassTypes: [BasicClassType] = []
    @Published public var selectedClassTypes: Set<BasicClassType> = []
    
    @Published public var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    @Published private var timetable: NormalisedTimetable?
    
    public var filteredSessions: [ClassSession] {
        guard let timetable = self.timetable else { return [] }
        
        return timetable.classesForDate(date: selectedDate)
            .filter { classInstance in
                (selectedInstructors.isEmpty || selectedInstructors.contains(where: { $0.name == classInstance.instructor.name }))
                && (selectedClassTypes.isEmpty || selectedClassTypes.contains(where: { $0.id == classInstance.lesMillsServiceId}))
            }
    }
    public var timetableDates: [Date]? {
        timetable?.dates
    }
    
    
    
    func loadData() {
        isLoading = true
        
        Task {
            do {
                async let clubsResponse = try await client.send(Paths.getClubs())
                async let contactDetailsResponse = try await client.send(Paths.getDetails())
                
                let (contactDetails, clubs) = try await (contactDetailsResponse.value.contactDetails, clubsResponse.value)
                
                await MainActor.run {
                    profile = contactDetails
                    allClubs = clubs.map { $0.clubDetailPage }
                }
                try await setSelectedClubs(Set(allClubs.filter { $0.id == profile?.homeClubGuid}))
            } catch {
                // TODO :shrug:
                print("Failed to load HomeViewModel \(error)")
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    func onClubsChange() async throws {
        async let instructorsResponse = try await client.send(Paths.getInstructors(clubs: selectedClubs)).value
        async let classesResponse = try await client.send(Paths.getAvailableClassTypes(clubs: selectedClubs)).value
        
        let (classes, instructors) = try await (classesResponse, instructorsResponse)
        
        await MainActor.run {
            allInstructors = instructors
            selectedInstructors = selectedInstructors.filter { instructors.contains($0) }
            
            allClassTypes = classes
            selectedClassTypes = selectedClassTypes.filter { classes.contains($0) }
        }
        
        try await refreshTimetable()
    }
    
    func refreshTimetable() async throws {
        let responses = await withTaskGroup(of: GetTimetableResponse.self) { group in
            for club in selectedClubs {
                group.addTask {
                    // TODO bad try!
                    try! await self.client.send(Paths.getTimetable(club: club)).value
                }
            }
            
            var responses = [GetTimetableResponse]()
            for await response in group {
                responses.append(response)
            }
            return responses
        }
        
        let timetable = NormalisedTimetable(responses: responses)
        
        await MainActor.run {
            self.timetable = timetable
            
            // If the timetable is for different dates, update the selected date
            if !timetable.dates.isEmpty && !timetable.dates.contains(selectedDate) {
                selectedDate = timetable.dates.first!
            }
        }
    }
}

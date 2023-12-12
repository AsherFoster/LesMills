//
//  ClassesViewModel.swift
//  LesMills
//
//  Created by Asher Foster on 12/12/23.
//

import Combine
import Foundation

class ClassesViewModel: ViewModel {
    @Published var profile: UserContactDetails? = nil
    @Published public var allClubs: [ClubDetailPage] = []
    
    @Published public var selectedClubs: Set<ClubDetailPage> = [] {
        didSet {
            Task {
                try await onClubsChange()
            }
        }
    }
    
    @Published public var allInstructors: [InstructorFromList] = []
    @Published public var selectedInstructors: Set<InstructorFromList> = [] {
        didSet {
            Task {
                try await onFilterChange()
            }
        }
    }
    
    @Published public var allClassTypes: [ClassType] = []
    @Published public var selectedClassTypes: Set<ClassType> = [] {
        didSet {
            Task {
                try await onFilterChange()
            }
        }
    }
    
    @Published public var timetable: NormalisedTimetable?
    @Published public var viewingDate: DateComponents?
    
    public var classes: [ClassInstance]? {
        guard let date = viewingDate else { return nil }
        guard let timetable = self.timetable else { return nil }
        
        return timetable.classesForDate(date: date)
            .filter { classInstance in
                (selectedInstructors.isEmpty || selectedInstructors.contains(where: { $0.name == classInstance.instructor.name }))
                && (selectedClassTypes.isEmpty || selectedClassTypes.contains(where: { $0.id == classInstance.lesMillsServiceId}))
            }
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
                    selectedClubs = Set(allClubs.filter { $0.id == profile?.homeClubGuid})
                }
                
                try await onClubsChange()
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
        async let classesResponse = try await client.send(Paths.getAllClasses(clubs: selectedClubs)).value
        
        let (classes, instructors) = try await (classesResponse, instructorsResponse)
        
        await MainActor.run {
            allInstructors = instructors
            selectedInstructors = selectedInstructors.filter { instructors.contains($0) }
            
            allClassTypes = classes
            selectedClassTypes = selectedClassTypes.filter { classes.contains($0) }
        }
        
        try await onFilterChange()
    }
    
    func onFilterChange() async throws {
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
            
            if viewingDate == nil || !timetable.dates.contains(viewingDate!) {
                viewingDate = timetable.dates.first
            }
        }
    }
}

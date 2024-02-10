import Combine
import Foundation
import Factory

class ClassesViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient
    
    @Published public var isLoading = false
    @Published public var profile: UserProfile? = nil
    
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
    
    @Published public var allClassTypes: [ClassType] = []
    @Published public var selectedClassTypes: Set<ClassType> = []
    
    @Published public var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    @Published private var timetable: NormalisedTimetable?
    
    public var timetableDates: [Date]? {
        timetable?.dates
    }
    
    /// A filtered view of `allInstructors` that limits to instructors that are in the current week's timetable
    public var instructorsInTimetable: [BasicInstructor] {
        if let timetable = self.timetable {
            return allInstructors.filter { instructor in
                timetable.classes.contains { $0.instructor.name == instructor.name}
            }
        }
        return []
    }
    
    func filteredSessions(forDate: Date) -> [ClassSession] {
        guard let timetable = self.timetable else { return [] }
        
        return timetable.classesForDate(date: forDate)
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
                async let contactDetailsResponse = try await client.getProfile()
                
                let (contactDetails, clubs) = try await (contactDetailsResponse, clubsResponse.value)
                
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
    
    static func mock() -> ClassesViewModel {
        let model = ClassesViewModel()
        model.profile = .mock()
        model.allClubs = [.mock()]
        model.selectedClubs = Set(model.allClubs)
        model.allInstructors = [BasicInstructor(name: "Instructor")]
        model.allClassTypes = [ClassType(id: "1", name: "Foo")]
        model.timetable = .mock()
        return model
    }
}

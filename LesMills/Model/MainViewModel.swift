import Foundation
import Factory

class MainViewModel: ObservableObject {
    init(profile: UserProfile) {
        self.profile = profile
        
        Task {
            do {
                async let bookingListResponse = try await client.send(Paths.getBookingList())
                async let clubsResponse = try await client.send(Paths.getClubs())
                
                let (bookingList, clubs) = try await (bookingListResponse.value.scheduleClassBooking, clubsResponse.value)
                
                await MainActor.run {
                    bookedSessions = bookingList.map { $0.toClassSession(clubs: allClubs, classTypes: allClassTypes) }
                    allClubs = clubs.map { $0.clubDetailPage }
                }
                try await setSelectedClubs(Set(allClubs.filter { $0.id == profile.homeClubGuid}))
            } catch {
                // TODO :shrug:
                print("Failed to load MainViewModel \(error)")
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    @Injected(\.client) private var client: LesMillsClient
    
    @Published public var isLoading: Bool = true
    @Published public var profile: UserProfile
    @Published public var bookedSessions: [ClassSession]? = nil
    
    @Published public var allClubs: [Club] = []
    @Published public private(set) var selectedClubs: Set<Club> = []
    public func setSelectedClubs(_ newClubs: Set<Club>) async throws {
        await MainActor.run {
            selectedClubs = newClubs
        }
        try await onClubsChange()
    }
    
    @Published public var allInstructors: [String] = []
    @Published public var selectedInstructors: Set<String> = []
    
    @Published public var allClassTypes: [ClassType] = []
    @Published public var selectedClassTypes: Set<ClassType> = []
    
    @Published public var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    @Published public var timetable: Timetable?
    
    /// A filtered view of `allInstructors` that limits to instructors that are in the current week's timetable
    public var instructorsInTimetable: [String] {
        if let timetable = self.timetable {
            return allInstructors.filter { instructor in
                timetable.classes.contains { $0.instructor == instructor}
            }
        }
        return []
    }
    
    func filteredSessions(forDate: Date) -> [ClassSession] {
        guard let timetable = self.timetable else { return [] }
        
        return timetable.classesForDate(date: forDate)
            .filter { classSession in
                (selectedInstructors.isEmpty || selectedInstructors.contains(classSession.instructor))
                && (selectedClassTypes.isEmpty || selectedClassTypes.contains { $0.contains(apiID: classSession.apiID) })
            }
    }
    
    func onClubsChange() async throws {
        await MainActor.run {
            isLoading = true
        }
        
        async let instructorsResponse = try await client.send(Paths.getInstructors(clubs: selectedClubs)).value
        async let classesResponse = try await client.send(Paths.getGroupFitness()).value
        
        let (classes, instructors) = try await (classesResponse, instructorsResponse)
        
        await MainActor.run {
            allInstructors = instructors.map { $0.name }
            selectedInstructors = selectedInstructors.filter { allInstructors.contains($0) }
            
            allClassTypes = ClassType.aggregateFromGroupFitness(groupFitnessItems: classes).sorted(by: { $0.id < $1.id })
            selectedClassTypes = Set(allClassTypes).filter { newClass in selectedClassTypes.contains { $0.id == newClass.id }}
        }
        
        try await refreshTimetable()
    }
    
    func refreshTimetable() async throws {
        await MainActor.run {
            isLoading = true
        }
        
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
        
        let timetable = Timetable(responses: responses, classTypes: allClassTypes, clubs: allClubs)
        
        await MainActor.run {
            self.timetable = timetable
            
            // If the timetable is for different dates, update the selected date
            if !timetable.dates.isEmpty && !timetable.dates.contains(selectedDate) {
                selectedDate = timetable.dates.first!
            }
            
            isLoading = false
        }
    }
}

extension MainViewModel {
    static func mock(hasBookedSessions: Bool = true) -> MainViewModel {
        let model = MainViewModel(profile: .mock())
        if hasBookedSessions {
            model.bookedSessions = [.mock(), .mock()]
        }
        model.allClubs = [.mock()]
        model.selectedClubs = Set(model.allClubs)
        // ChatGPT reckons these are perfectly normal names
        model.allInstructors = ["Arnold Iron", "Skip Roper", "Sally Spin", "Wendy Weights", "Barb Bell"]
        model.allClassTypes = [.mock()]
        model.timetable = .mock()
        
        return model
    }
}

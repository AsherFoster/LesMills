import Foundation
import Factory

class MainViewModel: ObservableObject {
    var rootModel = RootViewModel()
    
    func load(rootModel: RootViewModel) async {
        self.rootModel = rootModel
        
        let homeClub = Set(rootModel.clubs.filter { $0.id == rootModel.profile!.homeClubGuid})
    
        await setSelectedClubs(homeClub)
        await MainActor.run {
            isLoading = false
        }
    }
    
    @Injected(\.client) private var client: LesMillsClient
    
    @Published public var isLoading: Bool = true
    public var profile: UserProfile { rootModel.profile! }
    
    
    public var allClubs: [Club] { rootModel.clubs }
    @Published public private(set) var selectedClubs: Set<Club> = []
    public func setSelectedClubs(_ newClubs: Set<Club>) async {
        await MainActor.run {
            selectedClubs = newClubs
        }
        try! await onClubsChange()
    }
    
    @Published public var allInstructors: [String] = []
    @Published public var selectedInstructors: Set<String> = []
    
    /// A filtered view of `allInstructors` that limits to instructors that are in the current week's timetable
    public var instructorsInTimetable: [String] {
        if let timetable = self.timetable {
            return allInstructors.filter { instructor in
                timetable.classes.contains { $0.instructor == instructor}
            }
        }
        return []
    }
    
    public var allClassTypes: [ClassType] { rootModel.classTypes }
    @Published public var selectedClassTypes: Set<ClassType> = []
    
    @Published public var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
    
    @Published public var timetable: Timetable?
    
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
        
        let instructors = try await client.send(Paths.getInstructors(clubs: selectedClubs)).value
        
        await MainActor.run {
            allInstructors = instructors.map { $0.name }
            selectedInstructors = selectedInstructors.filter { allInstructors.contains($0) }
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
        let rootModel = RootViewModel.mock(hasBookedSessions: hasBookedSessions)
        let model = MainViewModel()
        model.rootModel = rootModel
        model.isLoading = false
        model.selectedClubs = Set(model.allClubs)
        // ChatGPT reckons these are perfectly normal names
        model.allInstructors = ["Arnold Iron", "Skip Roper", "Sally Spin", "Wendy Weights", "Barb Bell"]
        model.timetable = .mock()
        
        return model
    }
}

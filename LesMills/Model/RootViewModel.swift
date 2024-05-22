import SwiftUI
import Foundation
import Factory

class RootViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient

    // State for root view
    @Published var isReady = false
    @Published var error: String?
    var isAuthenticated: Bool { profile != nil }
    
    // Commonly used data that gets fetched on load and shared through app
    @Published var profile: UserProfile?
    @Published public var bookedSessions: [ClassSession] = []
    @Published public var clubs: [Club] = []
    @Published public var classTypes: [ClassType] = []
    
    func load() async {
        do {
            let p = try await client.signInFromStorage()
            
            // Ok but surely there has to be a better way to do this
            await MainActor.run {
                profile = p
            }
            
            async let bookingListResponse = try await client.send(Paths.getBookingList()).value
                .scheduleClassBooking
            async let clubsResponse = try await client.send(Paths.getClubs()).value
                .map { $0.clubDetailPage }
            async let classesResponse = try await client.send(Paths.getGroupFitness()).value
            
            let (bookingList, rawClubs, classes) = try await (bookingListResponse, clubsResponse, classesResponse)
            
            await MainActor.run {
                classTypes = ClassType.aggregateFromGroupFitness(groupFitnessItems: classes).sorted(by: { $0.id < $1.id })
                clubs = rawClubs
                bookedSessions = bookingList
                    .map { $0.toClassSession(clubs: clubs, classTypes: classTypes) }
            }
        } catch {
            await MainActor.run {
                self.error = "Failed to startup :("
            }
        }
        await MainActor.run {
            isReady = true
        }
    }
    
    func doneLogin(profile: UserProfile) {
        self.profile = profile
    }
    
    func signOut() {
        try! client.signOut()
        profile = nil
    }
    
    func refreshBookings() async throws {
        let bookingList = try await client.send(Paths.getBookingList()).value
            .scheduleClassBooking
            .map { $0.toClassSession(clubs: clubs, classTypes: classTypes) }
        await MainActor.run {
            bookedSessions = bookingList
        }
    }
    
}

extension RootViewModel {
    static func mock(hasBookedSessions: Bool = true) -> RootViewModel {
        let model = RootViewModel()
        model.isReady = true
        model.profile = .mock()
        if hasBookedSessions {
            model.bookedSessions = [.mock(), .mock()]
        }
        model.classTypes = [.mock()]
        model.clubs = [.mock()]
        return model
    }
}

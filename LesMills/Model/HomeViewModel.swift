import Foundation
import Factory

class HomeViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient
    
    @Published var isLoading = true
    @Published var profile: UserContactDetails? = nil
    @Published var bookedSessions: [ClassSession]? = nil
    
    func loadData() {
        isLoading = true
        
        Task {
            do {
                async let contactDetailsReq = try await client.send(Paths.getDetails())
                async let bookingListReq = try await client.send(Paths.getBookingList())
                
                let (contactDetails, bookingList) = try await (contactDetailsReq.value.contactDetails, bookingListReq.value.scheduleClassBooking)
                
                await MainActor.run {
                    profile = contactDetails
                    bookedSessions = bookingList
                }
            } catch {
                // TODO :shrug:
                print("Failed to load HomeViewModel \(error)")
            }
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    static func mock(hasBookedSessions: Bool = true) -> HomeViewModel {
        let model = HomeViewModel()
        model.profile = .mock()
        if hasBookedSessions {
            model.bookedSessions = [.mock(), .mock()]
        }
        
        return model
    }
}

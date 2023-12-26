//
//  HomeViewModel.swift
//  LesMills
//
//  Created by Asher Foster on 16/12/23.
//

import Foundation

class HomeViewModel: ViewModel {
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
    
    static func mock() -> HomeViewModel {
        let model = HomeViewModel()
        model.profile = .mock()
        model.bookedSessions = [.mock()]
        
        return model
    }
}

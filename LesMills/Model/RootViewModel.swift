import SwiftUI
import Foundation
import Factory

class RootViewModel: ObservableObject {
    @Injected(\.client) var client: LesMillsClient

    @Published
    var isReady = false
    
    @Published
    var error: String?
    
    @Published
    var profile: UserProfile?
    var isAuthenticated: Bool { profile != nil }
    
    init() {
        Task {
            do {
                let p = try await client.signInFromStorage()
                
                // Ok but surely there has to be a better way to do this
                await MainActor.run {
                    profile = p
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
    }
    
    func doneLogin(profile: UserProfile) {
        self.profile = profile
    }
    
    func signOut() {
        try! client.signOut()
        profile = nil
    }
}

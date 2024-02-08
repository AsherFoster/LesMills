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
    var profile: UserContactDetails?
    var isAuthenticated: Bool { profile != nil }
    
    func startup() async {
        do {
            profile = try await client.signInFromStorage()
        } catch {
            self.error = "Failed to startup :("
        }
        isReady = true
    }
}

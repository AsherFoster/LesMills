import Foundation
import Factory
import SwiftUI
import Get

class ClassBookingModel: ObservableObject {
    enum BookingState {
        case idle(availability: ClassSession.SessionAvailability)
        case loading
        case failed(errorMessage: String)
        case booked
    }
    
    var session: ClassSession
    @Published var state: BookingState
    
    init(session: ClassSession) {
        self.session = session
        // TODO work out if class is already booked
        state = .idle(availability: session.availability)
    }
    
    @Injected(\.client) private var client: LesMillsClient
    private let feedback = UINotificationFeedbackGenerator()
    
    func bookSession() async {
        await MainActor.run {
            state = .loading
        }
        
        do {
            try await client.bookSession(session: session)
        } catch {
            let errorMessage = switch error {
            case LesMillsClient.BookingError.classAlreadyBooked:
                "You've already booked this class"
            case LesMillsClient.BookingError.classIsFull:
                "Class is full"
            case LesMillsClient.BookingError.networkError(let underlyingError):
                switch underlyingError {
                case let error as APIError:
                    error.errorDescription ?? "Something went wrong, but the API won't say what"
                default:
                    "Networkey notworkey"
                }
            case LesMillsClient.BookingError.lesMillsError(let message):
                "Les Mills didn't like that: \(message)"
            default:
                "Something went really wrong"
            }
            await MainActor.run {
                state = .failed(errorMessage: errorMessage)
            }
            await feedback.notificationOccurred(.error)
            return
        }
        
        // success
        await MainActor.run {
            state = .booked
        }
        await feedback.notificationOccurred(.success)
        
    }
    
    func reset() {
        state = .idle(availability: session.availability)
    }
    
    func removeBooking() async {
        let request = Paths.removeBooking(session: session)
        do {
            try await client.send(request)
        } catch {
            await MainActor.run {
                state = .failed(errorMessage: "Failed to unbook") // TODO
            }
            await feedback.notificationOccurred(.error)
            return
        }
        
        await MainActor.run {
            reset()
        }
        await feedback.notificationOccurred(.success)
    }
}

import Foundation
import SwiftUI

struct BookSessionButton: View {
    var session: ClassSession
    @StateObject var bookingModel: ClassBookingModel
    init(session: ClassSession) {
        self.session = session
        _bookingModel = StateObject(wrappedValue: ClassBookingModel(session: session))
    }

    var body: some View {
        action
            .alert(
                "Failed to book class",
                isPresented: Binding(
                    get: {
                        if case .failed = bookingModel.state {
                            true
                        } else {
                            false
                        }
                    },
                    set: { newValue in
                        bookingModel.reset()
                    }
                ),
                presenting: bookingModel.state
            ) { state in } message: { state in
                switch state {
                case .failed(let message):
                    Text(message)
                default:
                    Text("This isn't an error message! What are you doing here?")
                }
            }
    }
    
    @ViewBuilder
    var action: some View {
        switch bookingModel.state {
        case .idle(let availability):
            switch availability {
            case .available:
                Button("Book", systemImage: "plus") {
                    Task {
                        await bookingModel.bookSession()
                    }
                }
            case .sessionIsFull, .sessionInPast:
                Button("Book", systemImage: "plus") {}
                    .disabled(true)
            }
        case .loading:
            Button {} label: {
                ProgressView()
            }
                .disabled(true)
        case .failed(let errorMessage):
            Button("Failed", systemImage: "exclamationmark.triangle") {
                bookingModel.reset()
            }
        case .booked:
            Button("Booked", systemImage: "calendar.badge.checkmark", role: .destructive) {
                Task {
                    await bookingModel.removeBooking()
                }
            }
        }
    }
}

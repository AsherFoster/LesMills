import Foundation

extension LesMillsClient {
    enum BookingError: Error {
        case classAlreadyBooked
        case classIsFull
        case networkError(underlyingError: Error)
        case lesMillsError(message: String)
    }
    
    func bookSession(session: ClassSession) async throws {
        // Allow bookings = requires bookings
        let response: SaveBookingResponse
        do {
            if session.requiresBooking {
                let request = Paths.prepareBooking(session: session)
                response = (try await send(request)).value
            } else {
                let request = Paths.saveBooking(session: session)
                response = (try await send(request)).value
            }
        } catch {
            throw BookingError.networkError(underlyingError: error)
        }
        
        if response.message.addBookingResult != "AddToScheduleSingleSuccess" {
            throw switch response.message.addBookingResult {
            case "ClassAlreadyBooked":
                BookingError.classAlreadyBooked
            case "ClassIsFull":
                BookingError.classIsFull
            default:
                BookingError.lesMillsError(message: response.message.addBookingResult)
            }
        }
        
        // success!
    }
    
    func getProfile()  async throws -> UserProfile {
        let contactDetailsReq = try await send(Paths.getDetails())
        return contactDetailsReq.value.contactDetails
    }
}

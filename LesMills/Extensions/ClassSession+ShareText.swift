import Foundation

extension ClassSession {
    var shareText: String {
        var text = "\(name) - \(CommonDateFormats.dayAndTime.string(from: startsAt))"
        if let url = classUrl {
            text += "\n\n" + url
        }
        return text
    }
}

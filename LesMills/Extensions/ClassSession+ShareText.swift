import Foundation

extension ClassSession {
    var shareText: String {
        var text = "\(classType.name) - \(CommonDateFormats.dayAndTime.string(from: startsAt))"
        if let url = classType.websiteUrl {
            text += "\n\n" + url.absoluteString
        }
        return text
    }
}

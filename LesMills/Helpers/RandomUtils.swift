import Foundation

extension Array where Element: Hashable {
    /// Deduplicate a list, guaranteeing order
    func deduplicate() -> [Element] {
        var elementSet = Set<Element>()
        return self.filter { elementSet.insert($0).inserted }
    }
}

let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"

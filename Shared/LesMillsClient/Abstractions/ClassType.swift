import Foundation

struct ClassType: Hashable {
    let name: String
    let description: String?
    let websiteUrl: URL?
    
    let allNames: Set<String>
    let serviceIDs: Set<String>
    
    func contains(serviceID: String) -> Bool {
        serviceIDs.contains(serviceID)
    }
    
    static func aggregateFromGroupFitness(groupFitnessItems: [GroupFitnessItem]) -> [ClassType] {
        var grouped: [String: [GroupFitnessData]] = [:]
        
        for groupFitnessItem in groupFitnessItems {
            grouped[normaliseName(groupFitnessItem.ProductPage.name), default: []].append(groupFitnessItem.ProductPage)
        }
        
        
        return grouped.map { normalisedName, items in
            let websiteUrl: URL? = if let u = items.filter({ !$0.url.isEmpty }).map({ $0.url }).first { URL(string: u) } else { nil }
            
            return ClassType(
                name: normalisedName,
                description: items.filter{ !$0.description.isEmpty && $0.description != $0.name }.map { $0.description }.first,
                websiteUrl: websiteUrl,
                allNames: Set(items.map { $0.name}),
                serviceIDs: Set(items.map { $0.serviceId })
            )
        }
    }
    
    
    static let KNOWN_GARBAGE_SUFFIXES = [" 30", " 45", " 60"]
    static let KNOWN_GARBAGE_PREFIXES = ["NEW - ", "Virtual "]
    static let PRESERVE_CAPITALISATION = ["GRIT", "RPM"]
    private static func normaliseName(_ apiName: String) -> String {
        // Rule 1: If it ends in a duration, get rid of that
        var normalisedName = Substring(apiName)
        for suffix in KNOWN_GARBAGE_SUFFIXES {
            if normalisedName.hasSuffix(suffix) {
                normalisedName = normalisedName.dropLast(suffix.count)
            }
        }
        
        for prefix in KNOWN_GARBAGE_PREFIXES {
        if normalisedName.hasPrefix(prefix) {
            normalisedName = normalisedName.dropFirst(prefix.count)
        }
        }
        
        // Make everything Title Case except for certain words/acronyms which should be preserved
        // This is because Les Mills is obsessed with caps (CEREMONY!) inconsistent capitalisation (BodyAttack & BODYATTACK!)
        normalisedName = Substring(normalisedName.capitalized)
        for match in PRESERVE_CAPITALISATION {
            normalisedName.replace(try! Regex(match).ignoresCase(), with: match)
        }
        // Match Any Body*, capitalise it (BODY*), drop BODY (*), then append Body (Body*)
        if let match = normalisedName.firstMatch(of: /Body./) {
            let corrected = match.localizedUppercase.dropFirst("Body".count)
            normalisedName.replaceSubrange(match.range, with: "Body" + corrected)
        }
        
        return String(normalisedName)
    }
}

extension ClassType: Identifiable {
    var id: String { name.lowercased() }
}

extension ClassType {
    struct MockClassInstance {
        let name: String
        let duration: Int
        let color: String
        
        static let mocks: [MockClassInstance] = [
            MockClassInstance(name: "BodyAttack 45", duration: 45, color: "#FEC424"),
            MockClassInstance(name: "BodyBalance 45", duration: 45, color: "#C5E86C"),
            MockClassInstance(name: "BodyCombat 45", duration: 45, color: "#787121"),
            MockClassInstance(name: "BodyPump 45", duration: 45, color: "#FE0000"),
            MockClassInstance(name: "BodyPump", duration: 60, color: "#FE0000"),
            MockClassInstance(name: "CEREMONY", duration: 45, color: "#CCCCCC"),
            MockClassInstance(name: "Sprint", duration: 30, color: "#D2BE57"),
            MockClassInstance(name: "The Trip", duration: 40, color: "#000000"),
            MockClassInstance(name: "GRIT Strength", duration: 30, color: "#000000"),
            MockClassInstance(name: "GRIT Cardio", duration: 30, color: "#000000"),
            MockClassInstance(name: "BodyJam", duration: 60, color: "#FCF710"),
            MockClassInstance(name: "Barre", duration: 60, color: "#F09787")
        ]
    }
    static func mock() -> ClassType {
        let mockClass = MockClassInstance.mocks.randomElement()!
        
        return ClassType(
            name: mockClass.name,
            description: "Total body workout to gain strength and lean, toned muscle.",
            websiteUrl: URL(string: "https://www.lesmills.co.nz/group-fitness/classes/bodypump"),
            allNames: [mockClass.name],
            serviceIDs: ["17"]
        )
    }
}

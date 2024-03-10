//
//  ClassType.swift
//  LesMills
//
//  Created by Asher Foster on 4/03/24.
//

import Foundation

struct ClassType: Hashable {
    let name: String
    let apiTypes: [APIClassType]
    
    func contains(id: String) -> Bool {
        apiTypes.contains(where: { $0.id == id })
    }
    
    // Takes a list of underlying API types (BodyPump, BodyPump 45) and groups them into the actual class
    static func groupTypes(apiTypes: [APIClassType]) -> [ClassType] {
        var grouped: [String: [APIClassType]] = [:]
        
        for apiType in apiTypes {
            grouped[normaliseName(apiType.name), default: []].append(apiType)
        }
        
        return grouped.map { ClassType(name: $0, apiTypes: $1) }
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
    static func mock() -> ClassType {
        ClassType(
            name: "BodyPump",
            apiTypes: [
                APIClassType(id: "1", name: "BodyPump"),
                APIClassType(id: "2", name: "BodyPump 45")
            ]
        )
    }
}

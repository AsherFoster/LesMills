//
//  RandomUtils.swift
//  LesMills
//
//  Created by Asher Foster on 27/12/23.
//

import Foundation

extension Array where Element: Hashable {
    /// Deduplicate a list, guaranteeing order
    func deduplicate() -> [Element] {
        var elementSet = Set<Element>()
        return self.filter { elementSet.insert($0).inserted }
    }
}

//
//  CommonDateFormats.swift
//  LesMills
//
//  Created by Asher Foster on 27/12/23.
//

import Foundation

class CommonDateFormats {
    /// Tuesday
    static var dayOfWeek: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        return formatter
    }
    
    /// 6:30pm
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
    
    static let dayAndTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE 'at' h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
}

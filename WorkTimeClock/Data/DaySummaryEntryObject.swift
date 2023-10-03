//
//  DaySummaryEntryObject.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 17.09.23.
//

import Foundation

class DaySummaryEntryObject: Identifiable, Comparable {
    let tag: UUID
    let minutes: Int
    let description: String
    
    init(tag: UUID, minutes: Int, description: String) {
        self.tag = tag
        self.minutes = minutes
        self.description = description
    }
    
    static func == (lhs: DaySummaryEntryObject, rhs: DaySummaryEntryObject) -> Bool {
        lhs.tag == rhs.tag && lhs.minutes == rhs.minutes && lhs.description == rhs.description
    }
    
    static func < (lhs: DaySummaryEntryObject, rhs: DaySummaryEntryObject) -> Bool {
        lhs.tag.uuidString < rhs.tag.uuidString
    }
}

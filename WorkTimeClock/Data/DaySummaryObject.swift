//
//  DaySummaryObject.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 30.09.23.
//

import Foundation

class DaySummaryObject {
    let summaryEntries: [DaySummaryEntryObject]
    
    let hasOpenEntries: Bool
    let hasCrossingEntries: Bool
    let hasEndBeforeStart: Bool
    let hasGapsBetweenEntries: Bool
    
    init(summaryEntries: [DaySummaryEntryObject] = [], hasOpenEntries: Bool = false, hasCrossingEntries: Bool = false, hasEndBeforeStart: Bool = false, hasGapsBetweenEntries: Bool = false) {
        self.summaryEntries = summaryEntries
        self.hasOpenEntries = hasOpenEntries
        self.hasCrossingEntries = hasCrossingEntries
        self.hasEndBeforeStart = hasEndBeforeStart
        self.hasGapsBetweenEntries = hasGapsBetweenEntries
    }
}

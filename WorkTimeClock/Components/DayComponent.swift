//
//  Controller.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 16.09.23.
//

import Foundation

class DayComponent: BaseComponent {
    @Published var day: Date = Date.now
    @Published var entries: [DayEntryObject] = []
    @Published var summary: DaySummaryObject = DaySummaryObject()
    @Published var loadError: Bool = false
    
    override init() {
        super.init()
        loadDay()
        calculateSummary()
    }
    
    func getFormattedDate() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(day) {
            return "Heute"
        }
        if calendar.isDateInYesterday(day) {
            return "Gestern"
        }
        if calendar.isDateInTomorrow(day) {
            return "Morgen"
        }
        
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "dd. MMMM yyyy"
        return formatter.string(from: day)
    }
    
    func nextDay() {
        saveDay()
        loadError = false
        day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        entries = []
        summary = DaySummaryObject()
        loadDay()
        calculateSummary()
    }
    
    func previousDay() {
        saveDay()
        loadError = false
        day = Calendar.current.date(byAdding: .day, value: -1, to: day)!
        entries = []
        summary = DaySummaryObject()
        loadDay()
        calculateSummary()
    }
    
    func loadDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("Work Time Clock").appendingPathComponent("days")
        let file = path.appendingPathComponent("\(formatter.string(from: day)).json")
        
        do {
            if FileManager.default.fileExists(atPath: file.path) {
                entries = try JSONDecoder().decode([DayEntryObject].self, from: Data(contentsOf: file))
                loadError = false
            }
            print("[Controller] Loaded Day")
        } catch {
            loadError = true
            print("[Controller] Failed to load Day; \(error)")
        }
    }
    
    func saveDay() {
        if loadError {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("Work Time Clock").appendingPathComponent("days")
        let file = path.appendingPathComponent("\(formatter.string(from: day)).json")
        
        do {
            if !FileManager.default.fileExists(atPath: path.path) {
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true)
            }
            if !FileManager.default.fileExists(atPath: file.path) {
                if !entries.isEmpty {
                    try JSONEncoder().encode(entries).write(to: file)
                    print("[Controller] Saved Day")
                }
            } else {
                try JSONEncoder().encode(entries).write(to: file)
                print("[Controller] Saved Day")
            }
        } catch {
            print("[Controller] Failed to Save Day (\(file)); \(error)")
        }
    }
    
    func addDayEntry() {
        let entry = DayEntryObject(tag: TagObject.kTagDifferentUUID, description: "", startTime: Date.now)
        entries.append(entry)
        sortDayEntries()
        
        let indexBefore = entries.index(before: entries.firstIndex(of: entry)!)
        if indexBefore >= 0 {
            if entries[indexBefore].endTime == nil {
                entries[indexBefore].endTime = Date.now
            } else {
                entry.startTime = entries[indexBefore].endTime!
            }
        }
    }
    
    func sortDayEntries() {
        entries.sort()
    }
    
    func calculateSummary() {
        var summaryMap: [UUID:DaySummaryEntryObject] = [:]
        
        var hasOpenEntries: Bool = false
        var hasCrossingEntries: Bool = false
        var hasEndBeforeStart: Bool = false
        var hasGapsBetweenEntries: Bool = false
        
        for entry in entries {
            var minutes = 0
            if entry.endTime != nil {
                let calendar = Calendar.current
                let startComponents = calendar.dateComponents([.hour, .minute], from: entry.startTime)
                let endComponents = calendar.dateComponents([.hour, .minute], from: entry.endTime!)
                minutes = calendar.dateComponents([.minute], from: startComponents, to: endComponents).minute!
            }
            
            hasOpenEntries = hasOpenEntries || entry.endTime == nil
            hasEndBeforeStart = hasEndBeforeStart || (entry.endTime != nil ? entry.endTime! < entry.startTime : false)
            
            var description = entry.description
            if summaryMap.keys.contains(entry.tag) {
                let old = summaryMap[entry.tag]!
                
                minutes += old.minutes
                
                if description.isEmpty {
                    description = old.description
                } else {
                    if !old.description.contains(description) {
                        description = "\(old.description); \(description)"
                    } else {
                        description = old.description
                    }
                }
            }
            summaryMap[entry.tag] = DaySummaryEntryObject(tag: entry.tag, minutes: minutes, description: description)
        }
        
        var lastEndTime: Date?
        for entry in entries {
            if lastEndTime != nil {
                let calendar = Calendar.current
                let endComponents = calendar.dateComponents([.hour, .minute], from: lastEndTime!)
                let startComponents = calendar.dateComponents([.hour, .minute], from: entry.startTime)
                
                // Check for gap
                if calendar.dateComponents([.minute], from: endComponents, to: startComponents).minute! > 0 {
                    hasGapsBetweenEntries = true
                }
                
                // Check for overlap
                if calendar.dateComponents([.minute], from: endComponents, to: startComponents).minute! < 0 {
                    hasCrossingEntries = true
                }
            }
            lastEndTime = entry.endTime
        }
        
        summary = DaySummaryObject(summaryEntries: Array(summaryMap.values).sorted(), hasOpenEntries: hasOpenEntries, hasCrossingEntries: hasCrossingEntries, hasEndBeforeStart: hasEndBeforeStart, hasGapsBetweenEntries: hasGapsBetweenEntries)
    }
}

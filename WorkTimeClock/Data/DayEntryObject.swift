//
//  DayEntryObject.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 16.09.23.
//

import Foundation

class DayEntryObject: ObservableObject, Codable, Hashable, Identifiable, Comparable {
    let uuid: UUID
    @Published var tag: UUID
    @Published var description: String
    @Published var startTime: Date
    @Published var endTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case tag
        case description
        case startTime
        case endTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.tag = try container.decode(UUID.self, forKey: .tag)
        self.description = try container.decode(String.self, forKey: .description)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.endTime = try container.decode(Date?.self, forKey: .endTime)
    }
    
    init(tag: UUID, description: String, startTime: Date, endTime: Date? = nil) {
        self.uuid = UUID()
        self.tag = tag
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uuid, forKey: .uuid)
        try container.encode(tag, forKey: .tag)
        try container.encode(description, forKey: .description)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
    }
    
    static func == (lhs: DayEntryObject, rhs: DayEntryObject) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    static func < (lhs: DayEntryObject, rhs: DayEntryObject) -> Bool {
        return lhs.startTime < rhs.startTime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(tag)
        hasher.combine(description)
        hasher.combine(startTime)
        hasher.combine(endTime)
    }
}

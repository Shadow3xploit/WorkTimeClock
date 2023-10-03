//
//  TagObject.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 14.09.23.
//

import Foundation

class TagObject: Codable, ObservableObject, Hashable, Identifiable {
    static let kTagPauseUUID = UUID(uuidString: "00000000-0000-0000-0000-f80000000000")!
    static let kTagDifferentUUID = UUID(uuidString: "00000000-0000-0000-0000-ff0000000000")!
    
    let uuid: UUID
    let editable: Bool
    @Published var name: String
    @Published var visible: Bool
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case editable
        case name
        case visible
    }
    
    init(uuid: UUID = UUID(), editable: Bool = true, name: String = "", visible: Bool = true) {
        self.uuid = uuid
        self.editable = editable
        self.name = name
        self.visible = visible
    }
    
    required init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decode(UUID.self, forKey: .uuid)
        self.editable = try container.decode(Bool.self, forKey: .editable)
        self.name = try container.decode(String.self, forKey: .name)
        self.visible = try container.decode(Bool.self, forKey: .visible)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(uuid, forKey: .uuid)
        try container.encode(editable, forKey: .editable)
        try container.encode(name, forKey: .name)
        try container.encode(visible, forKey: .visible)
    }
    
    static func == (lhs: TagObject, rhs: TagObject) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
        hasher.combine(editable)
        hasher.combine(name)
        hasher.combine(visible)
    }
}

//
//  TagComponent.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 03.10.23.
//

import Foundation

class TagComponent: BaseComponent {
    @Published var tags: [TagObject] = []
    @Published var loadError: Bool = false
    
    override init() {
        super.init()
        self.loadTags()
    }
    
    func deleteTag(_ tag: TagObject) {
        tags.removeAll { t in
            t == tag
        }
        saveTags()
    }
    
    func toggleTagVisibility(_ tag: TagObject) {
        tag.visible.toggle()
        saveTags()
    }
    
    func addTag() {
        tags.append(TagObject())
    }
    
    func removeEmptyTags() {
        tags.removeAll { tag in
            tag.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        saveTags()
    }
    
    func loadTags() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("Work Time Clock")
        let file = path.appendingPathComponent("tags.json")
        
        do {
            if FileManager.default.fileExists(atPath: file.path) {
                tags = try JSONDecoder().decode([TagObject].self, from: Data(contentsOf: file))
                loadError = false
            }
            print("[Controller] Loaded Tags")
        } catch {
            loadError = true
            print("[Controller] Failed to load Tags")
        }
        
        if !tags.contains(where: { tag in
            tag.uuid == TagObject.kTagPauseUUID
        }) {
            tags.append(TagObject(uuid: TagObject.kTagPauseUUID, editable: false, name: "Pause"))
            saveTags()
        }
        
        if !tags.contains(where: { tag in
            tag.uuid == TagObject.kTagDifferentUUID
        }) {
            tags.append(TagObject(uuid: TagObject.kTagDifferentUUID, editable: false, name: "Anderes"))
            saveTags()
        }
    }
    
    func saveTags() {
        if loadError {
            return
        }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("Work Time Clock")
        let file = path.appendingPathComponent("tags.json")
        
        do {
            if !FileManager.default.fileExists(atPath: path.path) {
                try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true)
            }
            try JSONEncoder().encode(tags.filter({ tag in
                !tag.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            })).write(to: file)
            print("[Controller] Saved Tags")
        } catch {
            print("[Controller] Failed to Save Tags (\(file))")
        }
    }
}

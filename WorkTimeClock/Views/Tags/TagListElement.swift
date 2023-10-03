//
//  TagListElement.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 14.09.23.
//

import SwiftUI

struct TagListElement: View {
    @ObservedObject var tagComponent = ComponentManager.instance.getComponent(TagComponent.self)!
    @ObservedObject var tag: TagObject
    
    var body: some View {
        HStack {
            if tag.editable {
                TextField("Namen eingeben", text: $tag.name)
                    .textFieldStyle(.plain)
                
                Button {
                    tagComponent.toggleTagVisibility(tag)
                } label: {
                    Image(systemName: tag.visible ? "eye.slash" : "eye")
                }
                
                Button {
                    tagComponent.deleteTag(tag)
                } label: {
                    Image(systemName: "trash")
                }
            } else {
                Text(tag.name)
                Spacer()
            }
        }
        .padding(4)
        .onChange(of: tag.name) { newValue in
            tagComponent.saveTags()
        }
    }
}

struct TagListElement_Previews: PreviewProvider {
    static var previews: some View {
        TagListElement(tag: TagObject(editable: true, name: "Test"))
    }
}

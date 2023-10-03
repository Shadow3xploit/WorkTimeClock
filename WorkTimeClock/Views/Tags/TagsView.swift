//
//  SettingsTagsView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 14.09.23.
//

import SwiftUI

struct TagsView: View {
    @ObservedObject var tagComponent = ComponentManager.instance.getComponent(TagComponent.self)!
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    VStack {
                        HStack {
                            Text("Eigene Tags")
                                .font(.system(.title2))
                            
                            Spacer()
                            
                            Button {
                                tagComponent.addTag()
                            } label: {
                                Label("Neuer Tag", systemImage: "plus")
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        if tagComponent.tags.filter({ tag in
                            tag.editable
                        }).isEmpty {
                            Divider()
                            Text("Noch keine eigenen Tags hinzugefügt.")
                        }
                        
                        ForEach(tagComponent.tags) { tag in
                            if tag.editable {
                                Divider()
                                TagListElement(tag: tag)
                            }
                        }
                        
                    }
                    .padding(12)
                    .background()
                    .cornerRadius(12)
                }
                .padding(12)
            }
        }
        .onDisappear {
            tagComponent.removeEmptyTags()
        }
    }
}

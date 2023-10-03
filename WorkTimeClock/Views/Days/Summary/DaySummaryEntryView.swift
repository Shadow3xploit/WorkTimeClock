//
//  DaySummaryEntryView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 17.09.23.
//

import SwiftUI

struct DaySummaryEntryView: View {
    @ObservedObject var tagComponent = ComponentManager.instance.getComponent(TagComponent.self)!
    let entry: DaySummaryEntryObject
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(tagComponent.tags.first(where: { tag in
                    tag.uuid == entry.tag
                })?.name ?? "Unbekannter Tag")
                
                Spacer()
                
                Text("\(entry.minutes / 60)h \(entry.minutes % 60)m")
            }
            .font(.system(.title2))
            
            Divider()
            
            Text(entry.description.isEmpty ? "Keine Beschreibung vorhanden" : entry.description)
                .font(.system(.body))
                .italic()
                .multilineTextAlignment(.center)
                .onTapGesture {
                    if !entry.description.isEmpty {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([.string], owner: nil)
                        pasteboard.setString(entry.description, forType: .string)
                    }
                }
        }
        .padding(12)
        .background()
        .cornerRadius(12)
    }
}

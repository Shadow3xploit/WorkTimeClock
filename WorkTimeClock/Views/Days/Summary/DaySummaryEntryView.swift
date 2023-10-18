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
    
    @State var hoveringOverDescription = false
    
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
            
            ZStack {
                Text(entry.description.isEmpty ? "Keine Beschreibung vorhanden" : entry.description)
                    .font(.system(.body))
                    .italic()
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 36)
                
                HStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        if !entry.description.isEmpty && hoveringOverDescription {
                            Button {
                                let pasteboard = NSPasteboard.general
                                pasteboard.declareTypes([.string], owner: nil)
                                pasteboard.setString(entry.description, forType: .string)
                            } label: {
                                Image(systemName: "doc.on.doc")
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.background)
                            .clipShape(Capsule(style: .continuous))
                        }
                        Spacer()
                    }
                }
            }
            .onHover { hovering in
                withAnimation {
                    hoveringOverDescription = hovering
                }
            }
        }
        .padding(12)
        .background()
        .cornerRadius(12)
    }
}

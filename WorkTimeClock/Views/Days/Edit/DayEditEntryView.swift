//
//  DayTrackingEntryView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 16.09.23.
//

import SwiftUI

struct DayEditEntryView: View {
    @ObservedObject var dayComponent = ComponentManager.instance.getComponent(DayComponent.self)!
    @ObservedObject var tagComponent = ComponentManager.instance.getComponent(TagComponent.self)!
    
    @ObservedObject var entry: DayEntryObject
    @FocusState var descriptionFocused: Bool
    
    @State var descriptionPopupHintPresented: Bool = false
    @State var quickReplaceEntries: [DayEntryObject] = []
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    DatePicker("Start", selection: $entry.startTime, displayedComponents: .hourAndMinute)
                    
                    if entry.endTime != nil {
                        DatePicker("Ende", selection: Binding(get: {
                            return entry.endTime!
                        }, set: { value, transaction in
                            entry.endTime = value
                        }), displayedComponents: .hourAndMinute)
                    } else {
                        Button("Ende setzten") {
                            entry.endTime = Date.now
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                
                
                Picker("Tag", selection: $entry.tag) {
                    ForEach(tagComponent.tags.filter({ tag in
                        tag.uuid == TagObject.kTagDifferentUUID || tag.uuid == TagObject.kTagPauseUUID
                    }), id: \.self) { tag in
                        Text(tag.name)
                            .tag(tag.uuid)
                    }
                    
                    if tagComponent.tags.count > 2 {
                        Divider()
                    }
                    
                    ForEach(tagComponent.tags.filter({ tag in
                        (tag.visible || tag.uuid == entry.tag) && !(tag.uuid == TagObject.kTagDifferentUUID) && !(tag.uuid == TagObject.kTagPauseUUID)
                    }), id: \.self) { tag in
                        Text(tag.name)
                            .tag(tag.uuid)
                    }
                }

                
                TextField("Beschreibung", text: $entry.description, axis: .horizontal)
                    .textFieldStyle(.roundedBorder)
                    .labelsHidden()
                    .onSubmit {
                        DispatchQueue.main.async {
                            NSApp.keyWindow?.makeFirstResponder(nil)
                        }
                        descriptionPopupHintPresented = false
                    }
                    .focused($descriptionFocused)
                    .onChange(of: descriptionFocused, perform: { focused in
                        descriptionPopupHintPresented = focused && !quickReplaceEntries.isEmpty
                    })
                    .popover(isPresented: $descriptionPopupHintPresented, arrowEdge: .top) {
                        VStack(alignment: .leading, spacing: 4){
                            ForEach(quickReplaceEntries) { entry in
                                Button{
                                    //When user clicks on the suggestion, replace text with suggestion and process it
                                    self.entry.description = entry.description
                                    self.entry.tag = entry.tag
                                    dayComponent.saveDay()
                                    if quickReplaceEntries.isEmpty {
                                        descriptionPopupHintPresented = false
                                    }
                                } label: {
                                    Text("\(getTagName(entry)) | \(entry.description)")
                                        .lineLimit(1)
                                        .frame(width: 200, alignment: .leading)
                                }
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(10)
                    }
            }
        }
        .padding(8)
        .background()
        .cornerRadius(8)
        .onAppear {
            updateQuickReplaceEntries()
        }
        .onChange(of: entry.tag) { newValue in
            dayComponent.saveDay()
        }
        .onChange(of: entry.description) { newValue in
            dayComponent.saveDay()
            updateQuickReplaceEntries()
        }
        .onChange(of: entry.startTime) { newValue in
            withAnimation {
                dayComponent.sortDayEntries()
            }
            dayComponent.saveDay()
        }
        .onChange(of: entry.endTime) { newValue in
            dayComponent.saveDay()
        }
    }
    
    private func updateQuickReplaceEntries() {
        quickReplaceEntries = Array(Set(dayComponent.entries))
            .filter({ entry in
                (self.entry.tag != entry.tag || self.entry.description != entry.description) && !entry.description.isEmpty && entry.description.lowercased().starts(with: self.entry.description.lowercased())
            })
            .sorted { first, second in
                if first.tag == second.tag {
                    return first.description < second.description
                } else {
                    let firstTag = tagComponent.tags.first { tag in
                        tag.uuid == first.tag
                    }
                    let secondTag = tagComponent.tags.first { tag in
                        tag.uuid == second.tag
                    }
                    if firstTag == nil {
                        return false
                    }
                    if secondTag == nil {
                        return true
                    }
                    return firstTag!.name < secondTag!.name
                }
            }
    }
                                                                    
    private func getTagName(_ entry: DayEntryObject) -> String{
        return tagComponent.tags.first(where: { tag in
            entry.tag == tag.uuid
        })!.name
    }
}

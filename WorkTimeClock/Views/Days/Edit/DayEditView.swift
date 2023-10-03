//
//  DayTrackingView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 14.09.23.
//

import SwiftUI

struct DayEditView: View {
    @ObservedObject var dayComponent = ComponentManager.instance.getComponent(DayComponent.self)!
    
    var body: some View {
        if dayComponent.loadError {
            VStack {
                Spacer()
                Text("Einträge konnten nicht geladen werden")
                    .font(.system(.title2))
                    .bold()
                    .multilineTextAlignment(.center)
                Button("Erneut versuchen") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dayComponent.loadDay()
                    }
                }
                Button("Tag neu beginnen", role: .destructive) {
                    dayComponent.loadError = false
                }
                Spacer()
            }
        } else {
            List {
                if !dayComponent.entries.isEmpty {
                    ForEach(dayComponent.entries) { entry in
                        DayEditEntryView(entry: entry)
                            .listRowSeparator(.hidden)
                    }
                    .onDelete { indexes in
                        for index in indexes {
                            dayComponent.entries.remove(at: index)
                        }
                        dayComponent.saveDay()
                    }
                } else {
                    HStack {
                        Spacer()
                        Text("Es wurden noch keine Zeiten erfasst.")
                        Spacer()
                    }
                    .padding(.vertical, 16)
                    .listRowSeparator(.hidden)
                }
                
                HStack {
                    Spacer()
                    Button {
                        dayComponent.addDayEntry()
                    } label: {
                        Label("Hinzufügen", systemImage: "plus")
                    }
                    .keyboardShortcut(KeyboardShortcut(KeyEquivalent("n")))
                    Spacer()
                }
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
        }
    }
}

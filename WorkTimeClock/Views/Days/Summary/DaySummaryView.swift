//
//  DaySummaryView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 16.09.23.
//

import SwiftUI

struct DaySummaryView: View {
    @ObservedObject var dayComponent = ComponentManager.instance.getComponent(DayComponent.self)!
    
    var body: some View {
        VStack {
            if dayComponent.loadError {
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
            } else {
                if !dayComponent.summary.summaryEntries.isEmpty {
                    List {
                        if dayComponent.summary.hasOpenEntries || dayComponent.summary.hasCrossingEntries || dayComponent.summary.hasEndBeforeStart || dayComponent.summary.hasGapsBetweenEntries {
                            DaySummaryErrorView()
                                .listRowSeparator(.hidden)
                        }
                        
                        ForEach(dayComponent.summary.summaryEntries) { entry in
                            DaySummaryEntryView(entry: entry)
                                .listRowSeparator(.hidden)
                        }
                    }
                } else {
                    Spacer()
                    Text("Keine Übersicht verfügbar.\nEs wurden noch keine Zeiten erfasst.")
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            }
        }
        .onAppear {
            dayComponent.calculateSummary()
        }
    }
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DaySummaryView()
    }
}

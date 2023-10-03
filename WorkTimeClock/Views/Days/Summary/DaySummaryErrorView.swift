//
//  DaySummaryErrorView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 30.09.23.
//

import SwiftUI

struct DaySummaryErrorView: View {
    @ObservedObject var dayComponent = ComponentManager.instance.getComponent(DayComponent.self)!
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Einträge fehlerhaft")
                    .bold()
                Spacer()
            }
            .font(.system(.title2))
            
            Divider()
            
            if dayComponent.summary.hasOpenEntries {
                HStack {
                    Text("Offene Enden")
                    Spacer()
                }
            }
            
            if dayComponent.summary.hasCrossingEntries {
                HStack {
                    Text("Überlappende Einträge")
                    Spacer()
                }
            }
            
            if dayComponent.summary.hasEndBeforeStart {
                HStack {
                    Text("Enden vor Start")
                    Spacer()
                }
            }
            
            if dayComponent.summary.hasGapsBetweenEntries {
                HStack {
                    Text("Lücken zwischen Einträgen")
                    Spacer()
                }
            }
        }
        .padding(12)
        .background()
        .cornerRadius(12)
    }
}

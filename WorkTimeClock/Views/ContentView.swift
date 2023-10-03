//
//  ContentView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 22.08.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var tagComponent = ComponentManager.instance.getComponent(TagComponent.self)!
    @State fileprivate var page: Page = .edit
    
    var body: some View {
        if tagComponent.loadError {
            VStack {
                Text("Tags konnten nicht geladen werden")
                    .font(.system(.title2))
                    .bold()
                    .multilineTextAlignment(.center)
                Divider()
                Button("Erneut versuchen") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        tagComponent.loadTags()
                    }
                }
                Button("Standards wiederherstellen", role: .destructive) {
                    tagComponent.loadError = false
                }
            }
            .padding(.all)
        } else {
            VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Picker("", selection: $page) {
                                Text("Eintragen")
                                    .tag(Page.edit)
                                
                                Text("Übersicht")
                                    .tag(Page.summary)
                                
                                Text("Tags")
                                    .tag(Page.tags)
                            }
                            .pickerStyle(.segmented)
                            .labelsHidden()
                            
                            if page == .edit || page == .summary {
                                DaySelectorView()
                            }
                        }
                        .padding(12)
                        
                        Divider()
                    }
                    
                    
                    switch page {
                    case .edit:
                        DayEditView()
                    case .summary:
                        DaySummaryView()
                    case .tags:
                        TagsView()
                    }
            }
            .frame(height: 400)
        }
    }
}

fileprivate enum Page {
    case edit
    case summary
    case tags
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

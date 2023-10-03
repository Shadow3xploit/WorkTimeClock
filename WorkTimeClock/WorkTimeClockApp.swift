//
//  WorkTimeClockApp.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 22.08.23.
//

import SwiftUI

@main
struct WorkTimeClockApp: App {
    
    init() {
        ComponentManager.instance.registerComponents([
            DayComponent(),
            TagComponent()
        ])
    }
    
    var body: some Scene {
        MenuBarExtra("WorkTimeClock", systemImage: "clock") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

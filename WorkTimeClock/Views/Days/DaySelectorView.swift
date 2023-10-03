//
//  DateSelectorView.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 14.09.23.
//

import SwiftUI

struct DaySelectorView: View {
    @ObservedObject var dayComponent = ComponentManager.instance.getComponent(DayComponent.self)!
    
    var body: some View {
        HStack {
            Button {
                dayComponent.previousDay()
            } label: {
                Image(systemName: "arrowshape.left.fill")
            }
            
            Spacer()

            Text(dayComponent.getFormattedDate())
            
            Spacer()
            
            Button {
                dayComponent.nextDay()
            } label: {
                Image(systemName: "arrowshape.right.fill")
            }
        }
    }
}

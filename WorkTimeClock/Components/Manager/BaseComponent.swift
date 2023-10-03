//
//  BaseComponent.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 03.10.23.
//

import Foundation

class BaseComponent: ObservableObject {
    func getComponent<T: BaseComponent>(_ component: T.Type) -> T? {
        return ComponentManager.instance.getComponent(component)
    }
}

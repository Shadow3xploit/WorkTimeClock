//
//  ComponentManager.swift
//  WorkTimeClock
//
//  Created by Christoph Schlüter on 03.10.23.
//

import Foundation

class ComponentManager {
    public static let instance = ComponentManager()
    
    private var components: [BaseComponent] = []
    
    func registerComponent(_ component: BaseComponent) {
        self.components.append(component)
    }
    
    func registerComponents(_ components: [BaseComponent]) {
        for component in components {
            self.components.append(component)
        }
    }
    
    func getComponent<T: BaseComponent>(_ component: T.Type) -> T? {
        for component in self.components {
            if component is T {
                return component as? T
            }
        }
        return nil
    }
}

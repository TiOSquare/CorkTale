//
//  DIContainer.swift
//  App
//
//  Created by 홍기웅 on 3/13/25.
//

import Foundation
import Presentation
import Data
import Domain
import Shared

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private var dependencies: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        dependencies[key] = instance
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        return dependencies[key] as? T
    }
    
    func unregister<T>(_ type: T.Type) {
        let key = String(describing: type)
        dependencies.removeValue(forKey: key)
    }
}


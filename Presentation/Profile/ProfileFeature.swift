//
//  ProfileFeature.swift
//  CorkTale
//
//  Created by Finley on 12/11/24.
//

import ComposableArchitecture

public struct ProfileFeature: Reducer {

    public init() {
    }
    
    public struct State: Equatable {
        var showSomething: Bool = true
        public init() {
        }
    }
    public enum Action: Equatable {
        case viewWillAppear
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .viewWillAppear:
            return .none
        }
    }
}

//
//  MainFeature.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import ComposableArchitecture

public struct MainFeature: Reducer {
    public init() {}
    
    public struct State: Equatable {
        var selectedTab: Tab = .home
        public init() {}
    }
    
    public enum Action: Equatable {
        case selectTab(Tab)
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
            state.selectedTab = tab
            return .none
        }
    }
}

public enum Tab: Hashable {
    case home, location, search, profile, music
}

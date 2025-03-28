//
//  MainFeature.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import ComposableArchitecture

public struct MainFeature: Reducer {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: TabItem = .home
        public init() {}
    }
    
    @CasePathable
    public enum Action: Equatable {
        case tabItemDidChanged(TabItem)
    }
    
    public var body: some ReducerOf<MainFeature> {
        Reduce { state, action in
            switch action {
                
            case .tabItemDidChanged(let newTabItem):
                if state.selectedTab != newTabItem {
                    state.selectedTab = newTabItem
                }
                return .none
                
            }
        }
    }
}

public enum TabItem: Hashable, CaseIterable {
    case home, location, search, profile, music
    
    var image: String {
        switch self {
        case .home: return "house.fill"
        case .location: return "map.fill"
        case .search: return "magnifyingglass"
        case .profile: return "person.fill"
        case .music: return "music.note"
        }
    }
    
    var text: String {
        switch self {
        case .home: return "홈"
        case .location: return "매장탐색"
        case .search: return "와인검색"
        case .profile: return "마이페이지"
        case .music: return "음악"
        }
    }
}

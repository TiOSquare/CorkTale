//
//  MainView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI
import ComposableArchitecture
import Domain

public struct MainView: View {
    private let factory: StoreFactory
    @Bindable var store: StoreOf<MainFeature>
    
    public init(factory: StoreFactory) {
        self.factory = factory
        self.store = factory.makeMainFeatureStore()
    }
    
    public var body: some View {
        
        TabView(selection: $store.selectedTab) {
            
            ForEach(TabItem.allCases, id: \.self) { item in
                TabItemView(item)
                    .tag(item)
                    .tabItem {
                        Image(systemName: item.image)
                        Text(item.text)
                    }
            }
        }
    }
    
    @ViewBuilder
    func TabItemView(_ tab: TabItem) -> some View {
        
        switch tab {
        case .home:
            HelloView(factory: self.factory)
            
        case .location:
            WineStoreMapView(factory: self.factory)
            
        case .music:
            Text("music")
            
        case .profile:
            ProfileView(factory: self.factory)
            
        case .search:
            WineSearchView(factory: self.factory)
        }
    }
}


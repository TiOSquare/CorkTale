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
    private let store: StoreOf<MainFeature>
    
    public init(factory: StoreFactory) {
        self.factory = factory
        self.store = factory.makeMainFeatureStore()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Group {
                    CurrentMainView(for: store.selectedTab)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut, value: store.selectedTab)
                
                MainTabBar(with: geometry.size)
            }
        }
    }
    
    @ViewBuilder
    private func MainTabBar(with size: CGSize) -> some View {
        
        let width = size.width
        let height = width / 6
        
        HStack {
            ForEach(TabItem.allCases, id: \.self) { item in
                
                Button {
                    store.send(.tabItemDidChanged(item))
                } label: {
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: item.image)
                        Text(item.text)
                            .lineLimit(1)
                            .font(.caption2)
                    }
                    .foregroundStyle(store.selectedTab == item ? .pink : .gray)
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(width: width, height: height)
        .background(Color(.systemBackground))
        
    }
    
    @ViewBuilder
    private func CurrentMainView(for tab: TabItem) -> some View {
        
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


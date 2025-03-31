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
    
    @State private var selectedTab: TabItem = .home
    
    public init(factory: StoreFactory) {
        self.factory = factory
        self.store = factory.makeMainFeatureStore()
    }
    
    public var body: some View {
//        body1()
//        body2()
//        body3()
        body4()
    }
    
    private func body1() -> some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                ForEach(TabItem.allCases, id: \.self) { item in
                    
                    CurrentMainView(for: item)
                        .tabItem {
                            Image(systemName: item.image)
                            Text(item.text)
                        }
                        .tag(item)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut, value: selectedTab)
            
        }
    }
    
    private func body2() -> some View {
        VStack(spacing: 0) {
            TabView {
                ForEach(TabItem.allCases, id: \.self) { item in
                    
                    CurrentMainView(for: item)
                        .tag(item)
                        .tabItem {
                            Image(systemName: item.image)
                            Text(item.text)
                        }
                        .badge(3)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut, value: store.selectedTab)
            
        }
    }
    
    @ViewBuilder
    private func body3() -> some View {
        if #available(iOS 18.0, *) {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    ForEach(TabItem.allCases, id: \.self) { item in
                        
                        Tab(item.text, systemImage: item.image, value: item) {
                            CurrentMainView(for: item)
                        }
                        
//                        Tab(item.text, systemImage: item.image) {
//                            CurrentMainView(for: item)
//                        }
                        .badge("!")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut, value: store.selectedTab)
            }
        }
    }
    
    private func body4() -> some View {
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


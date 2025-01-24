//
//  MainView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI
import ComposableArchitecture
import Presentation
import Data

public struct MainView: View {
    let store: StoreOf<MainFeature>
    
    public init(store: StoreOf<MainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0 },
                send: MainFeature.Action.selectTab
            )) {
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature(profileRepository: ProfileRepositoryImpl())
                }), repository: ProfileRepositoryImpl())
                .tag(Tab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature(profileRepository: ProfileRepositoryImpl())
                }), repository: ProfileRepositoryImpl())
                .tag(Tab.location)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("매장탐색")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature(profileRepository: ProfileRepositoryImpl())
                }), repository: ProfileRepositoryImpl())
                .tag(Tab.search)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("와인검색")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature(profileRepository: ProfileRepositoryImpl())
                }), repository: ProfileRepositoryImpl())
                .tag(Tab.profile)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature(profileRepository: ProfileRepositoryImpl())
                }), repository: ProfileRepositoryImpl())
                .tag(Tab.music)
                .tabItem {
                    Image(systemName: "music.note")
                    Text("음악")
                }
            }
        }
    }
}

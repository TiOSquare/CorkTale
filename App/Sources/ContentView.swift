import SwiftUI
import ComposableArchitecture
import Presentation

struct AppFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
    }
    enum Action: Equatable {
        case selectTab(Tab)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
            state.selectedTab = tab
            return .none
        }
    }
}


public struct ContentView: View {
//    @Perception.Bindable var store: StoreOf<AppFeature>
    let store: StoreOf<AppFeature>
    
//    public var body: some View {
//            WithPerceptionTracking {
//                TabView(selection: $store.currentPageId.sending(\.changePage)) {
//                        ForEach(
//                            store.scope(
//                                state: \.pages,
//                                action: \.pages
//                            ),
//                            id: \.id
//                        ) { pagesStore in
//                                switch pagesStore.case {
//                                case let .profileFeature(profileFeatureStore):
//                                    ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
//                                        ProfileFeature()
//                                    }))
//                                    .tag(Tab.home)
//                                    .tabItem {
//                                        Image(systemName: "house.fill")
//                                        Text("홈")
//                                    }
//                                case let .profileFeature(profileFeatureStore):
//                                    ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
//                                        ProfileFeature()
//                                    }))
//                                    .tag(Tab.location)
//                                    .tabItem {
//                                        Image(systemName: "location.fill")
//                                        Text("홈")
//                                    }
//                                case let .profileFeature(profileFeatureStore):
//                                    ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
//                                        ProfileFeature()
//                                    }))
//                                    .tag(Tab.search)
//                                    .tabItem {
//                                        Image(systemName: "search.fill")
//                                        Text("홈")
//                                    }
//                                case let .profileFeature(profileFeatureStore):
//                                    ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
//                                        ProfileFeature()
//                                    }))
//                                    .tag(Tab.profile)
//                                    .tabItem {
//                                        Image(systemName: "profile.fill")
//                                        Text("홈")
//                                    }
//                                case let .profileFeature(profileFeatureStore):
//                                    ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
//                                        ProfileFeature()
//                                    }))
//                                    .tag(Tab.music)
//                                    .tabItem {
//                                        Image(systemName: "music.fill")
//                                        Text("홈")
//                                    }
//                                }
//                        
//                    }
//                }
//                .tabViewStyle(.page)
//            }
//        }
    public var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(
                get: { $0 },
                send: AppFeature.Action.selectTab
            )) {
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .tag(Tab.home)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .tag(Tab.location)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("매장탐색")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .tag(Tab.search)
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("와인검색")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .tag(Tab.profile)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
                ProfileView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .tag(Tab.music)
                .tabItem {
                    Image(systemName: "music.note")
                    Text("음악")
                }
            }
        }
    }
}

enum Tab: Hashable {
    case home, location, search, profile, music
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(initialState: AppFeature.State(), reducer: {
            AppFeature()
        }))
    }
}

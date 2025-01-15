//
//  SearchView.swift
//  Presentation
//
//  Created by 홍기웅 on 1/13/25.
//

import ComposableArchitecture
import SwiftUI

public struct WineSearchView: View {
    
    // MARK: - Variables
    
//    @Bindable var store: StoreOf<WineSearchFeature>
    @Perception.Bindable var store: StoreOf<WineSearchFeature>

    @State var text: String = ""
    
    public init(store: StoreOf<WineSearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                
                HStack {
                    Button(action: {
                        store.send(.cameraButtonDidTapped)

                    }, label: {
                        Image(systemName: "text.viewfinder")
                    })
                }
                .searchable(text: $store.searchText, placement: .navigationBarDrawer, prompt: Text("Wine Search"))
                .onSubmit(of: .search) {
                    store.send(.searchButtonDidTapped)
                }
            }
            .onAppear {
                store.send(.viewDidApear)
            }
            .onDisappear {
                store.send(.viewDidDisappear)
            }
            .fullScreenCover(isPresented: $store.isPresentedCameraSheet) {
                CameraView(store: store.scope(state: \.cameraState, action: \.cameraAction))
            }
        }
    }
}

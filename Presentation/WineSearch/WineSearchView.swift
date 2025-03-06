//
//  SearchView.swift
//  Presentation
//
//  Created by 홍기웅 on 1/13/25.
//

import ComposableArchitecture
import SwiftUI
import Domain

public struct WineSearchView: View {
    
    // MARK: - Variables
    @Bindable var store: StoreOf<WineSearchFeature>

    public init(store: StoreOf<WineSearchFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            
            VStack {
                List {
                    ForEach(store.state.searchResult, id: \.id) { wine in
                        WineListItemView(wine: wine)
                    }
                }
            }
            .navigationTitle("Wine Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button(action: {
                        store.send(.cameraButtonDidTapped)
                        
                    }, label: {
                        Image(systemName: "text.viewfinder")
                    })
                })
            }
            .searchable(
                text: $store.searchText,
                placement: .navigationBarDrawer,
                prompt: Text("Wine Search")
            )
            .onSubmit(of: .search) {
                store.send(.searchButtonDidTapped)
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

private struct WineListItemView: View {
    
    let wine: Wine
    
    var body: some View {
        HStack {
            CachedAsyncImage(
                url: URL(string: wine.thumb)!,
                content: { image in
                    
                image
                    .resizable()
                    .scaledToFit()
                    
            }, placeholder: {
                Image(systemName: "photo")
            })
            .frame(width: 120)
            
            VStack {
                Text("\(wine.name)")
                Text("⭐️: \(wine.averageRating ?? 0.0)")
                Text("\(wine.price ?? 0.0)")
            }
        }
    }
}

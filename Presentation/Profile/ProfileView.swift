//
//  Untitled.swift
//  CorkTale
//
//  Created by Finley on 12/11/24.
//
import SwiftUI
import ComposableArchitecture
import Domain

public struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    ProfileHeaderView(store: .init(initialState: ProfileHeaderFeature.State(), reducer: {
                        ProfileHeaderFeature()
                    }))
                        .padding(.top, 30)
                    
//                    if let emblems = viewStore.profile?.emblem {
//                        ProfileEmblemView(emblems: emblems)
//                    } else {
                        Text("No emblems available")
                            .font(.subheadline)
                            .foregroundColor(.gray)
//                    }
                }
            }
        }
    }
}







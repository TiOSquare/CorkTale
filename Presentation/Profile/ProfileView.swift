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
        NavigationView {
            VStack {
                ProfileHeaderView(store: .init(initialState: ProfileFeature.State(), reducer: {
                    ProfileFeature()
                }))
                .padding(.top, 30)
                Text("No emblems available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}






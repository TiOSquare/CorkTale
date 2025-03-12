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
    
    public var body: some View {
        NavigationView {
            VStack {
                ProfileHeaderView(store: store)
                .padding(.top, 30)
                Text("No emblems available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}






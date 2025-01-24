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
    let repository: ProfileRepository
    
    public init(store: StoreOf<ProfileFeature>, repository: ProfileRepository) {
        self.store = store
        self.repository = repository
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                ProfileHeaderView(repository: repository)
                .padding(.top, 30)
                Text("No emblems available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}






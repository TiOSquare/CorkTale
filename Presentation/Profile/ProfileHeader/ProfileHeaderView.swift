//
//  SwiftUIView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI
import ComposableArchitecture
import Domain

struct ProfileHeaderView: View {
    
    let store: StoreOf<ProfileFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                HStack {
                    ZStack {
                        Image(systemName: store.profileImage)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    VStack {
                        Text(store.profile?.nickname ?? "")
                            .font(.headline)
                        Text(store.profile?.nationality ?? "")
                            .font(.subheadline)
                        Text(String(store.profile?.level ?? 0))
                            .font(.subheadline)
                    }
                }
                NavigationLink(destination: ProfileEditView(store: .init(initialState: ProfileEditFeature.State(), reducer: {
                    ProfileEditFeature()
                }))) {
                    Text("Edit Profile")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                }
                .onAppear {
                    self.store.send(.viewWillAppear)
                }
            }
        }
    }
}

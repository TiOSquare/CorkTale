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
    
    let store: StoreOf<ProfileHeaderFeature>
    
    public init(store: StoreOf<ProfileHeaderFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    ZStack {
                        Image(systemName: viewStore.profileImage)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    VStack {
                        Text(viewStore.nickname)
                            .font(.headline)
                        Text(viewStore.nationality)
                            .font(.subheadline)
                        Text(String(viewStore.level))
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
            }
        }
    }
}

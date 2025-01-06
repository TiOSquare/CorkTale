//
//  SwiftUIView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI
import ComposableArchitecture

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<ProfileEditFeature>
    
    public init(store: StoreOf<ProfileEditFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            Text("Profile Edit Screen")
                .font(.largeTitle)
                .padding()
        }
    }
}

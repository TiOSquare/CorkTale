//
//  Untitled.swift
//  CorkTale
//
//  Created by Finley on 12/11/24.
//
import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Profile")
      }
}

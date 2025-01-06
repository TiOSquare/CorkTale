//
//  ProfileEditFeature.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//


import Domain
import ComposableArchitecture

public struct ProfileEditFeature: Reducer {

    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        case viewWillAppear
        case saveButtonTapped
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .viewWillAppear:
            return .none
        case let .saveButtonTapped:
            return .none
        }
    }
}

extension ProfileEditFeature {
    func loadProfile() {
        
    }
    
    func saveProfile() {
        
    }
}

//
//  ProfileHeaderFeature.swift
//  CorkTale
//
//  Created by Finley on 12/13/24.
//

import ComposableArchitecture

public struct ProfileHeaderFeature: Reducer {

    public init() {}
    
    public struct State: Equatable {
        var profileImage: String = "person.circle"
        var nickname: String = "-"
        var nationality: String = "-"
        var level: Int = 0
    }
    
    public enum Action: Equatable {
        case viewWillAppear
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .viewWillAppear:
            return .none
        }
    }
}

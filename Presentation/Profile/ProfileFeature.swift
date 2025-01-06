//
//  ProfileFeature.swift
//  CorkTale
//
//  Created by Finley on 12/11/24.
//

import ComposableArchitecture
import Domain

public struct ProfileFeature: Reducer {

    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var profileImage: String = ""
        var nickname: String = ""
        var nationality: String = ""
        var level: Int = 0
    }
    
    public enum Action: Equatable {
        case viewWillAppear
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .viewWillAppear:
            fetchProfile()
            return .none
        }
    }
    
    private func fetchProfile() {
//        self.profile = Profile(
//            nickname: "공주강아지",
//            profileImage: "person.circle",
//            level: 0,
//            nationality: "France",
//            emblem: ["emblem01", "emblem02", "emblem03", "emblem04"]
//        )
    }
}

//
//  ProfileFeature.swift
//  CorkTale
//
//  Created by Finley on 12/11/24.
//

import Foundation
import Combine
import ComposableArchitecture
import Domain

public struct ProfileFeature: Reducer {
    
    private enum CancellableID {
        static let profile = "profile"
        static let profileImage = "profileImage"
        static let nickname = "nickname"
        static let nationality = "nationality"
        static let level = "level"
    }
    
    private let profileRepository: ProfileRepository
    public init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool = false
        
        var profile: Profile?
        var profileImage: String = ""
        var nickname: String = ""
        var nationality: String = ""
        var level: Int = 0
        var emblem: [String] = []
        
        var errorMessage: String?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case viewWillAppear
        
        case updateProfile(Profile)
        
        case updatedErrorText(String)
        case clearErrorText
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewWillAppear:
            return self.reqProfile(repository: self.profileRepository)
        case .updateProfile(let user):
            state.profile = user
            return .none
        case .updatedErrorText(let text):
            state.errorMessage = text
            return .none
        case .clearErrorText:
            state.errorMessage = nil
            return .none
        }
    }
    
    private func reqProfile(repository: ProfileRepository) -> Effect<Action> {
        return .run { send in
            do {
                let profile = try await repository.getProfile()
                await send(.updateProfile(profile))
            } catch {
                await send(.updatedErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.profile, cancelInFlight: true)
    }
}

//
//  ProfileUseCase.swift
//  CorkTale
//
//  Created by Finley on 2/19/25.
//

public protocol ProfileUseCase {
    func createProfile(profile: Profile) async throws -> Profile
    func getProfile() async throws -> Profile
    func updateProfile(profile: ProfileEdit) async throws -> Profile
}

public final class ProfileUseCaseImpl: ProfileUseCase {
    private let repository: ProfileRepository
    
    public init(repository: ProfileRepository) {
        self.repository = repository
    }
    public func createProfile(profile: Profile) async throws -> Profile {
        return try await self.repository.createProfile(profile: profile)
    }
    
    public func getProfile() async throws -> Profile {
        return try await self.repository.getProfile()
    }
    
    public func updateProfile(profile: ProfileEdit) async throws -> Profile {
        return try await self.repository.updateProfile(profile: profile)
    }
}

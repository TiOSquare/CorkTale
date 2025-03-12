//
//  ProfileUseCase.swift
//  CorkTale
//
//  Created by Finley on 2/19/25.
//

public protocol ProfileUseCase {
    func createProfile(nickName: String, profileImage: String, level: Int, nationality: String, emblem: [String]) async throws -> Domain.Profile
    func getProfile() async throws -> Profile
    func updateProfile(nickName: String, profileImage: String) async throws -> Int
}

public final class ProfileUseCaseImpl: ProfileUseCase {
    private let repository: ProfileRepository
    
    public init(repository: ProfileRepository) {
        self.repository = repository
    }
    public func createProfile(nickName: String, profileImage: String, level: Int, nationality: String, emblem: [String]) async throws -> Profile {
        return try await self.repository.createProfile(nickName: nickName, profileImage: profileImage, level: level, nationality: nationality, emblem: emblem)
    }
    
    public func getProfile() async throws -> Profile {
        return try await self.repository.getProfile()
    }
    
    public func updateProfile(nickName: String, profileImage: String) async throws -> Int {
        return try await self.repository.updateProfile(nickName: nickName, profileImage: profileImage)
    }
}

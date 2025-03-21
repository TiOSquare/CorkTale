//
//  ProfileRepository.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//



import Combine

public protocol ProfileRepository {
    func createProfile(profile: Profile) async throws -> Profile
    func getProfile() async throws -> Profile
    func updateProfile(profile: ProfileEdit) async throws -> Profile
}

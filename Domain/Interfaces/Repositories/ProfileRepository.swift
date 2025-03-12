//
//  ProfileRepository.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//



import Combine

public protocol ProfileRepository {
    func createProfile(nickName: String, profileImage: String, level: Int, nationality: String, emblem: [String]) async throws -> Profile
    func getProfile() async throws -> Profile
    func updateProfile(nickName: String, profileImage: String) async throws -> ProfileEdit
}

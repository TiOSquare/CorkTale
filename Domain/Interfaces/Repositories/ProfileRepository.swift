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
    func getNickname() async throws -> String
    func getProfileImage() async throws -> String
    func getLevel() async throws -> Int
    func getNationality() async throws -> String
}

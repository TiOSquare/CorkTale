//
//  ProfileImpl.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//

import Combine
import Foundation
import Domain

public final class ProfileRepositoryImpl: ProfileRepository {
    private let provider = RestNetworkProvider()
    
    public init() { }
    
    public func createProfile(nickName: String, profileImage: String, level: Int, nationality: String, emblem: [String]) async throws -> Domain.Profile {
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.createProfile(nickName, profileImage, level, nationality, emblem))
        
        return response.data!.toDomain()
    }
    
    public func getProfile() async throws -> Profile {
        do {
            let rawData = try await self.provider.request(ProfileAPI.getAllProfile)
            let profileDTO = try JSONDecoder().decode(ProfileDTO.self, from: rawData)
            return profileDTO.toDomain()
        } catch {
            throw error
        }
    }
    
    public func getNickname() async throws -> String {
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.getNickname)
        guard let data = response.data?.toDomain(type: ProfileDetail.nickname) as? String else { return String() }
        
        return data
    }
    
    public func getProfileImage() async throws -> String {
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.getProfileImage)
        guard let data = response.data?.toDomain(type: ProfileDetail.profileImage) as? String else { return String() }
        
        return data
    }
    
    public func getLevel() async throws -> Int {
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.getLevel)
        guard let data = response.data?.toDomain(type: ProfileDetail.level) as? Int else { return Int() }
        
        return data
    }
    
    public func getNationality() async throws -> String {
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.getNationality)
        guard let data = response.data?.toDomain(type: ProfileDetail.nationality) as? String else { return String() }
        
        return data
    }
}


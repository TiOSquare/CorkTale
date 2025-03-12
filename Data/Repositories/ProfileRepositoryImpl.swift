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
    
    public func createProfile(nickName: String, profileImage: String, level: Int, nationality: String, emblem: [String]) async throws -> Profile {
        let profileDTO = ProfileDTO(nickname: nickName,
                                    profileImage: profileImage,
                                    level: level,
                                    nationality: nationality,
                                    emblem: emblem)
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.createProfile(profileDTO))
        
        return response.data!.toDomain()
    }
    
    public func getProfile() async throws -> Profile {
        let response: RestResponse<ProfileDTO> = try await self.provider.request(ProfileAPI.getAllProfile)
        
        return response.data!.toDomain()
    }
    
    public func updateProfile(nickName: String, profileImage: String) async throws -> ProfileEdit {
        let profileEditDTO = ProfileEditDTO(nickname: nickName,
                                    profileImage: profileImage)
        
        let response: RestResponse<ProfileEditDTO> = try await
        self.provider.request(ProfileAPI.updateProfile(profileEditDTO))
        return response.data!.toDomain()
    }
}


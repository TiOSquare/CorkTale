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
    
    public func createProfile(profile: Profile) async throws -> Profile {
        let profileDTO = ProfileDTO(nickname: profile.nickname,
                                    profileImage: profile.profileImage,
                                    level: profile.level,
                                    nationality: profile.nationality,
                                    emblem: profile.emblem)
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.createProfile(profileDTO))
        
        return response.data!.toDomain()
    }
    
    public func getProfile() async throws -> Profile {
        let response: RestResponse<ProfileDTO> = try await self.provider.request(ProfileAPI.getAllProfile)
        
        return response.data!.toDomain()
    }
    
    public func updateProfile(profile: ProfileEdit) async throws -> Profile {
        let profileDTO = ProfileEditDTO(nickname: profile.nickname, profileImage: profile.profileImage)
        
        let response: RestResponse<ProfileDTO> = try await
        self.provider.request(ProfileAPI.updateProfile(profileDTO))
        return response.data!.toDomain()
    }
}


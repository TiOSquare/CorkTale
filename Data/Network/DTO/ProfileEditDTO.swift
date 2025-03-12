//
//  ProfileEditDTO.swift
//  CorkTale
//
//  Created by Finley on 3/6/25.
//

import Domain

enum ProfileEditDetail {
    case nickname
    case profileImage
}

struct ProfileEditDTO: Codable {
    let nickname: String
    let profileImage: String
}

extension ProfileEditDTO {
    func toDomain() -> ProfileEdit {
        return ProfileEdit(
            nickname: nickname,
            profileImage: profileImage
        )
    }
    
    func toDomain(type: ProfileEditDetail) -> Any {
        switch type {
        case .nickname:
            return self.nickname
        case .profileImage:
            return self.profileImage
        }
    }
}

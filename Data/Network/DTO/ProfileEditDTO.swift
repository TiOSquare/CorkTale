//
//  ProfileEditDTO.swift
//  CorkTale
//
//  Created by Finley on 3/6/25.
//

import Domain

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
}

//
//  ProfileDTO.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//

import Domain

struct ProfileDTO: Codable {
    let nickname: String
    let profileImage: String
    let level: Int
    let nationality: String
    let emblem: [String]
}

extension ProfileDTO {
    func toDomain() -> Profile {
        return Profile(
            nickname: nickname,
            profileImage: profileImage,
            level: level,
            nationality: nationality,
            emblem: emblem
        )
    }
}

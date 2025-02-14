//
//  ProfileDTO.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//

import Domain

enum ProfileDetail {
    case nickname
    case profileImage
    case level
    case nationality
    case emblem
}

struct ProfileDTO: Decodable, Encodable {
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
    
    func toDomain(type: ProfileDetail) -> Any {
        switch type {
        case .nickname:
            return self.nickname
        case .profileImage:
            return self.profileImage
        case .level:
            return self.level
        case .nationality:
            return self.nationality
        case .emblem:
            return self.emblem
        }
    }
    
    
}

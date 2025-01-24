//
//  Untitled.swift
//  CorkTale
//
//  Created by Finley on 12/13/24.
//

import Foundation

public struct Profile {
    let nickname: String
    let profileImage: String
    let level: Int
    let nationality: String
    let emblem: [String]
    
    public init(nickname: String, profileImage: String, level: Int, nationality: String, emblem: [String]) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.level = level
        self.nationality = nationality
        self.emblem = emblem
    }
}

extension Profile: Equatable {
    public static func == (lhs: Profile, rhs: Profile) -> Bool {
        //TODO: ID추가해서 수정
        return lhs.nickname == rhs.nickname
    }
}

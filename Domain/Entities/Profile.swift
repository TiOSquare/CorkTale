//
//  Untitled.swift
//  CorkTale
//
//  Created by Finley on 12/13/24.
//

import Foundation

public struct Profile {
    public private(set) var nickname: String
    public private(set) var profileImage: String
    public private(set) var level: Int
    public private(set) var nationality: String
    public private(set) var emblem: [String]
    
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

//
//  Untitled.swift
//  CorkTale
//
//  Created by Finley on 12/13/24.
//

import Foundation

struct Profile {
    let nickname: String
    let profileImage: String
    let level: Int
    let nationality: String
    let emblem: [String]
    
    init(nickname: String, profileImage: String, level: Int, nationality: String, emblem: [String]) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.level = level
        self.nationality = nationality
        self.emblem = emblem
    }
}


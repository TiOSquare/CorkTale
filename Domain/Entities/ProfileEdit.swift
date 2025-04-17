//
//  ProfileEdit.swift
//  CorkTale
//
//  Created by Finley on 3/6/25.
//

public struct ProfileEdit {
    public private(set) var nickname: String
    public private(set) var profileImage: String
    
    public init(nickname: String, profileImage: String) {
        self.nickname = nickname
        self.profileImage = profileImage
    }
}

extension ProfileEdit: Equatable {
    public static func == (lhs: ProfileEdit, rhs: ProfileEdit) -> Bool {
        //TODO: ID추가해서 수정
        return lhs.nickname == rhs.nickname
    }
}

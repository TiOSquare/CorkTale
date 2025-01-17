//
//  HelloUser.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/24/24.
//

public struct HelloUser {
    let id: String
    let name: String
    
    public var description: String {
        return "id: \(id), name: \(name)"
    }
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension HelloUser: Equatable {
    public static func == (lhs: HelloUser, rhs: HelloUser) -> Bool {
        return lhs.id == rhs.id
    }
}

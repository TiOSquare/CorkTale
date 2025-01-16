//
//  HelloUserDTO.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/24/24.
//

import Domain

struct HelloUserDTO: Decodable {
    let id: String
    let name: String
}

extension HelloUserDTO {
    func toDomain() -> HelloUser {
        return HelloUser(id: self.id, name: self.name)
    }
}

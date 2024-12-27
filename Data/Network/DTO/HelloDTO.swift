//
//  HelloDTO.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/23/24.
//

struct HelloDTO: Decodable {
    let msg: String
}

extension HelloDTO {
    func toDomain() -> String {
        return self.msg
    }
}

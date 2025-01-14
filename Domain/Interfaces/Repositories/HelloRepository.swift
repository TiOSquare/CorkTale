//
//  HelloRepository.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/23/24.
//

// TODO: 가이드용 샘플. 추후 삭제 예정

import Combine

public protocol HelloRepository {
    func sayHello() async throws -> String
    func sayHello(with id: String) async throws -> String
    func sayHelloUser(id: String, name: String) async throws -> HelloUser
}

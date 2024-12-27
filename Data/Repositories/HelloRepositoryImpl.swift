//
//  HelloRepositoryImpl.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/23/24.
//

// TODO: 가이드용 샘플. 추후 삭제 예정

import Combine
import Foundation

import Domain

public final class HelloRepositoryImpl: HelloRepository {
    private let provider = RestNetworkProvider()
    
    public init() { }
    
    public func sayHello() async throws -> String {
        let response: RestResponse<HelloDTO> = try await self.provider.request(HelloAPI.hello)
        
        return response.data!.toDomain()
    }
    
    public func sayHello(with id: String) async throws -> String {
        let response: RestResponse<HelloDTO> = try await self.provider.request(HelloAPI.helloWithID(id))
        
        return response.data!.toDomain()
    }
    
    public func sayHelloUser(id: String, name: String) async throws -> HelloUser {
        let response: RestResponse<HelloUserDTO> = try await self.provider.request(HelloAPI.helloUser(id, name))
        
        return response.data!.toDomain()
    }
}


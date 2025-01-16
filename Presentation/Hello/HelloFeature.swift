//
//  HelloFeature.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/24/24.
//

import Combine
import Foundation

import ComposableArchitecture

import Domain

public final class HelloFeature: Reducer {
 
    private enum CancellableID {
        static let hello = "HelloID"
        static let helloID = "HelloIDID"
        static let helloUser = "HelloUserID"
    }
    
    private let helloRepository: HelloRepository
    
    public init(helloRepository: HelloRepository) {
        self.helloRepository = helloRepository
    }
    
    @ObservableState
    public struct State: Equatable {
        var helloText: String = ""
        var helloIDText: String = ""
        var helloUser: HelloUser?
        
        var errorText: String?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case viewWillAppear
        
        case requestHello
        case requestHelloID
        case requestHelloUser
        
        case updatedHelloText(String)
        case updatedHelloIDText(String)
        case updatedHelloUser(HelloUser)
        
        case updatedErrorText(String)
        case clearErrorText
    }
    
    public func reduce(
        into state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .viewWillAppear:
            let num = self.randomNum()
            let id = "ididid\(num)"
            let name = "name\(num)"
            print("viewWillAppear \(id) \(name)")
            return Effect.merge([
                self.reqHello(repository: self.helloRepository),
                self.reqHelloID(repository: self.helloRepository, id: id),
                self.reqHelloUser(repository: self.helloRepository, id: id, name: name)
            ])
            
        case .requestHello:
            return self.reqHello(repository: self.helloRepository)
            
        case .requestHelloID:
            let id = "id\(self.randomNum())"
            print("requestHelloID \(id)")
            return self.reqHelloID(
                repository: self.helloRepository,
                id: id
            )
            
        case .requestHelloUser:
            let num = self.randomNum()
            let id = "ididid\(num)"
            let name = "name\(num)"
            print("requestHelloUser \(id) \(name)")
            return self.reqHelloUser(
                repository: self.helloRepository,
                id: id,
                name: name
            )
            
        case .updatedHelloText(let text):
            print("updateHelloText \(text)")
            state.helloText = text
            return .none
            
        case .updatedHelloIDText(let text):
            print("updateHelloIDText \(text)")
            state.helloIDText = text
            return .none
            
        case .updatedHelloUser(let user):
            print("updateHelloUser \(user.description)")
            state.helloUser = user
            return .none
            
        case .updatedErrorText(let text):
            print("updateErrorText \(text)")
            state.errorText = text
            return .none
            
        case .clearErrorText:
            state.errorText = nil
            return .none
        }
    }
    
    private func randomNum() -> Int {
        return Int.random(in: 0 ..< 1000)
    }
    
    private func reqHello(repository: HelloRepository) -> Effect<Action> {
        return .run { send in
            do {
                let helloText = try await repository.sayHello()
                await send(.updatedHelloText(helloText))
            } catch {
                await send(.updatedErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.hello, cancelInFlight: true)
    }
    
    private func reqHelloID(
        repository: HelloRepository,
        id: String
    ) -> Effect<Action> {
        return .run { send in
            do {
                let helloIDText = try await repository.sayHello(with: id)
                await send(.updatedHelloIDText(helloIDText))
            } catch {
                await send(.updatedErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.helloID, cancelInFlight: true)
    }
    
    private func reqHelloUser(
        repository: HelloRepository,
        id: String,
        name: String
    ) -> Effect<Action> {
        return .run { send in
            do {
                let helloUser = try await repository.sayHelloUser(id: id, name: name)
                await send(.updatedHelloUser(helloUser))
            } catch {
                await send(.updatedErrorText(error.localizedDescription))
            }
        }
        .cancellable(id: CancellableID.helloUser, cancelInFlight: true)
    }
    
}

//
//  WineUseCase.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/13/25.
//

public protocol WineUseCase {
    func search(name: String) async throws -> [Wine]
}

public final class WineUseCaseImpl: WineUseCase {
    private let repository: WineRepository
    
    public init(repository: WineRepository) {
        self.repository = repository
    }
    
    public func search(name: String) async throws -> [Wine] {
        return try await self.repository.scrape(matching: name)
    }
}

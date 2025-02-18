//
//  WineRepositoryImpl.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/13/25.
//

import Foundation

import Domain

public final class WineRepositoryImpl: WineRepository {
    
    public init() { }
    
    public func search(name: String) async throws -> [Wine] {
        do {
            return try await HTMLScraper().scrapeWines(searchQuery: name)
                .compactMap { WineDTO(from: $0) }
                .map { $0.toDomain() }
        }
    }
}

//
//  WineRepository.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/13/25.
//

public protocol WineRepository {
    func scrape(matching name: String) async throws -> [Wine]
}

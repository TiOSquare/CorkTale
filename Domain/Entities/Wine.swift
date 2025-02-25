//
//  Wine.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/13/25.
//

public struct Wine: Equatable, Identifiable {
    public let id: Int
    public let name: String
    public let link: String
    public let thumb: String
    public let averageRating: Double?
    public let ratings: Int?
    public let price: Double?
    
    public init(
        id: Int,
        name: String,
        link: String,
        thumb: String? = nil,
        averageRating: Double? = nil,
        ratings: Int? = nil,
        price: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.link = link
        self.thumb = thumb ?? ""
        self.averageRating = averageRating
        self.ratings = ratings
        self.price = price
    }
}

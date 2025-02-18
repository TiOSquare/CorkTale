//
//  WineDTO.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/12/25.
//

import Foundation

import Domain
import Shared

struct WineDTO: Decodable {
    let id: Int
    let name: String
    let link: String
    let thumb: String?
    let country: String
    let region: String
    let averageRating: Double?
    let ratings: Int?
    let price: Double?
    
    init?(from dict: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            let decoded = try JSONDecoder().decode(WineDTO.self, from: jsonData)
            self = decoded
        } catch {
            Log.make(with: .data).log(level: .error, "Decoding error: \(error)")
            return nil
        }
    }
}

extension WineDTO {
    func toDomain() -> Wine {
        return Wine(
            id: self.id,
            name: self.name,
            link: self.link,
            thumb: self.thumb,
            averageRating: self.averageRating,
            ratings: self.ratings,
            price: self.price
        )
    }
}

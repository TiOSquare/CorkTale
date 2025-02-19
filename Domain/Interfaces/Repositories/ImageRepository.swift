//
//  ImageRepository.swift
//  Domain
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation

public protocol ImageRepository {
    func fetch(forKey key: String, type: ImageType) async -> Data?
}

public enum ImageType {
    case thumbnail
    case original
    case test
}

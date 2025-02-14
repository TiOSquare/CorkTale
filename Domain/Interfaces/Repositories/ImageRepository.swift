//
//  ImageRepository.swift
//  Domain
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation

public protocol ImageRepository {
    func fetch(forKey: String) async -> Data?
}


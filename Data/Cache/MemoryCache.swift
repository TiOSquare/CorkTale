//
//  MemoryCache.swift
//  App
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation

class MemoryCache {
    
    private let memoryCache: NSCache<NSString, NSData> = .init()
    
    func fetch(forKey key: String) -> Data? {
        return memoryCache.object(forKey: key as NSString) as? Data
    }
    
    func store(_ data: Data, forKey key: String) {
        memoryCache.setObject(data as NSData, forKey: key as NSString)
    }
}

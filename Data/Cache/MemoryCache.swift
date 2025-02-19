//
//  MemoryCache.swift
//  App
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation

class MemoryCache {
    
    private class CacheItem {
        let data: Data
        let etag: String?
        
        init(data: Data, etag: String?) {
            self.data = data
            self.etag = etag
        }
    }
    
    private let cache: NSCache<NSString, CacheItem> = .init()
    
    func fetch(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString)?.data
    }
    
    func store(_ data: Data, etag: String? = nil, forKey key: String) {
        let cacheItem = CacheItem(data: data, etag: etag)
        cache.setObject(cacheItem, forKey: key as NSString)
    }
    
    func etag(forKey key: String) -> String? {
        return cache.object(forKey: key as NSString)?.etag
    }
    
    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}

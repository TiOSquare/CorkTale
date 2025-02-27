//
//  ImageCache.swift
//  Shared
//
//  Created by 홍기웅 on 2/25/25.
//

import Foundation

public final class ImageCache {
    
    private static let shared = ImageCache()
    private let memoryCache: MemoryCache = .init()
    
    private init() { }
    
    public static func fetch(forKey key: String) async -> Data? {
        guard let url = URL(string: key) else { return nil }
        
        if let memoryCachedData = shared.memoryCache.fetch(forKey: key) {
            return memoryCachedData
        }
        if let diskCachedData = DiskCache.fetch(forKey: key) {
            let etag = DiskCache.etag(forKey: key)
            shared.storeToMemoryCache(diskCachedData, etag: etag, forKey: key)
            return diskCachedData
        }
        
        return nil
    }
    
    public static func store(_ data: Data, etag: String? = nil, forKey key: String) {
        shared.storeToMemoryCache(data, etag: etag, forKey: key)
        shared.storeToDiskCache(data, etag: etag, forKey: key)
    }
    
    public static func etag(forKey key: String) -> String? {
        if let memoryCachedEtag = shared.memoryCache.etag(forKey: key) {
            return memoryCachedEtag
        }
        if let diskCachedEtag = DiskCache.etag(forKey: key) {
            return diskCachedEtag
        }
        return nil
    }
}

private extension ImageCache {
    
    private func storeToMemoryCache(_ data: Data, etag: String? = nil, forKey key: String) {
        self.memoryCache.store(data, etag: etag, forKey: key)
    }
    
    private func storeToDiskCache(_ data: Data, etag: String? = nil, forKey key: String) {
        DiskCache.store(data, etag: etag, forKey: key)
    }
}

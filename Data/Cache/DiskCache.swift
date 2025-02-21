//
//  DiskCache.swift
//  Data
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation
import Shared

class DiskCache {
    
    private static let fileManager: FileManager = FileManager.default
    private static let cachedDataName: String = "cachedData"
    private static let etagFileName: String = "etag"
    private static let logger = Log.make(with: .data)
    
    static func fetch(forKey key: String) -> Data? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return nil }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        return try? Data(contentsOf: cacheDataURL)
    }
    
    static func store(_ data: Data, etag: String? = nil, forKey key: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        try? fileManager.createDirectory(atPath: cacheDirectoryURL.path(), withIntermediateDirectories: true)
        fileManager.createFile(atPath: cacheDataURL.path(), contents: data)
        
        if let etag {
            let etagURL = cacheDirectoryURL.appending(path: etagFileName)
            try? etag.write(to: etagURL, atomically: true, encoding: .utf8)
        }
    }
    
    static func etag(forKey key: String) -> String? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return nil }
        let etagURL = cacheDirectoryURL.appending(path: etagFileName)
        return try? String(contentsOfFile: etagURL.path, encoding: .utf8)
    }
    
    static func remove(forKey key: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return }
        do {
            try fileManager.removeItem(at: cacheDirectoryURL)
        } catch {
            logger.log(level: .error, "Failed to remove disk cache for key \(key): \(error.localizedDescription)")
        }
    }
    
    static private func makeCacheDirectoryURL(forKey key: String) -> URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: key)
    }
}

//
//  DiskCache.swift
//  Data
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation

class DiskCache {
    
    private let fileManager: FileManager = .init()
    private let cachedDataName: String = "cachedData"
    private let etagFileName: String = "etag"
    
    func fetch(forKey key: String) -> Data? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return nil }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        return try? Data(contentsOf: cacheDataURL)
    }
    
    func store(_ data: Data, etag: String? = nil, forKey key: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        try? fileManager.createDirectory(atPath: cacheDirectoryURL.path(), withIntermediateDirectories: true)
        fileManager.createFile(atPath: cacheDataURL.path(), contents: data)
        
        if let etag {
            let etagURL = cacheDirectoryURL.appendingPathComponent(etagFileName)
            try? etag.write(to: etagURL, atomically: true, encoding: .utf8)
        }
    }
    
    func etag(forKey key: String) -> String? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return nil }
        let etagURL = cacheDirectoryURL.appendingPathComponent(etagFileName)
        return try? String(contentsOfFile: etagURL.path, encoding: .utf8)
    }
    
    func remove(forKey key: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return }
        try? fileManager.removeItem(at: cacheDirectoryURL)
    }
    
    private func makeCacheDirectoryURL(forKey key: String) -> URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: key)
    }
}

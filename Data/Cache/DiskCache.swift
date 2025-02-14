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
    
    func fetch(forKey key: String) -> Data? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return nil }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        return try? Data(contentsOf: cacheDataURL)
    }
    
    func store(_ data: Data, forKey key: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(forKey: key) else { return }
        let cacheDataURL = cacheDirectoryURL.appending(path: cachedDataName)
        try? fileManager.createDirectory(atPath: cacheDirectoryURL.path(), withIntermediateDirectories: true)
        fileManager.createFile(atPath: cacheDataURL.path(), contents: data)
    }
    
    private func makeCacheDirectoryURL(forKey key: String) -> URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: key)
    }
}

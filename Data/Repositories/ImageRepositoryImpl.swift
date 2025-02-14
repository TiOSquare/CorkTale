//
//  ImageRepositoryImpl.swift
//  Data
//
//  Created by 홍기웅 on 2/13/25.
//

import Foundation
import Domain
import Shared

public final class ImageRepositoryImpl: ImageRepository {
    
    private let memoryCache: MemoryCache = .init()
    private let diskCache: DiskCache = .init()
    private let logger = Log.make(with: .data)
    
    public init() { }
    
    public func fetch(forKey key: String) async -> Data? {
        if let memoryCachedData = self.memoryCache.fetch(forKey: key) {
            self.logger.log("memory cached image data")
            return memoryCachedData
        }
        
        if let diskCachedData = self.diskCache.fetch(forKey: key) {
            self.logger.log("disk cached image data")
            return diskCachedData
        }
        
        guard let url = URL(string: key) else { return nil }
        
        do {
            let downloadedData = try await self.download(from: url)
            self.logger.log("downloaded image data")
            self.store(downloadedData, forKey: key)
            return downloadedData
        } catch {
            return nil
        }
    }
    
    func store(_ data: Data, forKey key: String) {
        self.logger.log("cache image data to \(key)")
        memoryCache.store(data, forKey: key)
        diskCache.store(data, forKey: key)
    }
    
    func download(from url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
}

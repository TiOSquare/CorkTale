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
    
    private enum DownloadResult {
        case success(data: Data, etag: String?)
        case notModified
        case failure(Error)
    }

    private let memoryCache: MemoryCache = .init()
    private let diskCache: DiskCache = .init()
    private let logger = Log.make(with: .data)
    
    public init() { }
    
    public func fetch(forKey key: String, type: ImageType) async -> Data? {
        switch type {
        case .original:
            return await fetchOriginal(forKey: key)
        
        case .thumbnail:
            return await fetchThumbnail(forKey: key)
            
        case .test:
            return await fetchTest(forKey: key)
        }
    }
    
    private func fetchThumbnail(forKey key: String) async -> Data? {
        if let memoryCachedData = self.memoryCache.fetch(forKey: key) {
            self.logger.log("memory cached image data")
            return memoryCachedData
        }
        
        guard let url = URL(string: key) else { return nil }
        let downloadResult = await download(from: url)
        switch downloadResult {
        case .success(let downloadedData, _):
            self.logger.log("successfully downloaded image data")
            self.memoryCache.store(downloadedData, forKey: key)
            return downloadedData
            
        default:
            self.logger.log(level: .error, "failed to download image data")
            return nil
        }
    }
    
    private func fetchOriginal(forKey key: String) async -> Data? {
        guard let url = URL(string: key) else { return nil }
        
        let etag = self.etag(forKey: key)
        let result = await download(from: url, etag: etag)
        
        switch result {
        case .success(let downloadedData,let newEtag):
            self.logger.log("successfully downloaded image data")
            self.storeToCache(downloadedData, etag: newEtag, forKey: key)
            return downloadedData

        case .notModified:
            if let memoryCachedData = self.memoryCache.fetch(forKey: key) {
                return memoryCachedData
            }
            if let diskCachedData = self.diskCache.fetch(forKey: key) {
                self.memoryCache.store(diskCachedData, etag: etag, forKey: key)
                return diskCachedData
            }
            self.logger.log(level: .error, "failed to fetch image data")
            return nil

        default:
            self.logger.log(level: .error, "failed to fetch image data")
            return nil
        }
    }
    
    private func fetchTest(forKey key: String) async -> Data? {
        if let memoryCachedData = self.memoryCache.fetch(forKey: key) {
            self.logger.log("memory cached image data")
            return memoryCachedData
        }
        
        if let diskCachedData = self.diskCache.fetch(forKey: key) {
            self.logger.log("disk cached image data")
            self.memoryCache.store(diskCachedData, forKey: key)
            return diskCachedData
        }
        
        guard let url = URL(string: key) else { return nil }
        let result = await download(from: url)
        switch result {
        case .success(let downloadedData, _):
            self.logger.log("successfully downloaded image data")
            storeToCache(downloadedData, forKey: key)
            return downloadedData
            
        default:
            self.logger.log(level: .error, "failed to fetch image data")
            return nil
        }
    }
    
    private func etag(forKey key: String) -> String? {
        if let memoryCachedEtag = self.memoryCache.etag(forKey: key) {
            return memoryCachedEtag
        }
        if let diskCachedEtag = self.diskCache.etag(forKey: key) {
            return diskCachedEtag
        }
        return nil
    }
    
    private func storeToCache(_ data: Data, etag: String? = nil, forKey key: String) {
        self.logger.log("cache image data key: \(key), etag: \(String(describing: etag))")
        memoryCache.store(data, etag: etag, forKey: key)
        diskCache.store(data, etag: etag, forKey: key)
    }
    
    private func download(from url: URL, etag: String? = nil) async -> DownloadResult {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let etag {
            request.addValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) as? (Data, HTTPURLResponse) else {
            return .failure(URLError(.badServerResponse))
        }
        
        switch response.statusCode {
        case 200:
            let newEtag = response.allHeaderFields["Etag"] as? String
            return .success(data: data, etag: newEtag)
            
        case 304:
            return .notModified
            
        default:
            return .failure(URLError(.badServerResponse))
        }
    }
    
}


//
//  ImageLoader.swift
//  Shared
//
//  Created by 홍기웅 on 2/25/25.
//

import Foundation

public final class ImageLoader {
    
    private static let shared = ImageLoader()
    
    public enum DownloadResult {
        case success(data: Data, etag: String?)
        case notModified
        case failure(Error)
    }
    
    private init() { }
    
    
    public static func download(from url: URL, etag: String? = nil) async -> DownloadResult {
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

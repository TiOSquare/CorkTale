//
//  HTMLScraper.swift
//  CorkTale
//
//  Created by jinhyerim on 2/11/25.
//

import Foundation
import SwiftSoup

public final class HTMLScraper {
    
    private enum Constant {
        static let userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36"
    }
    
    let logger = Log.make(with: .shared)
    
    public static let shared = HTMLScraper()
    
    private init() {}
    
    public func fetchHTML(from urlString: String) async throws -> String? {
        guard let url = URL(string: urlString) else {
            let error = URLError(.badURL)
            self.logger.log(level: .error, error.localizedDescription)
            throw error
        }
        
        var request = URLRequest(url: url)
        request.setValue(Constant.userAgent, forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await URLSession.shared.data(for: request)

        guard let html = String(data: data, encoding: .utf8) else {
            let error = URLError(.cannotDecodeRawData)
            self.logger.log(level: .error, error.localizedDescription)
            throw error
        }
        
        return html
    }
    
}

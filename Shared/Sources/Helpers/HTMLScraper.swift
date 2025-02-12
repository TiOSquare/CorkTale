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
    
    public func fetchHTML(
        from urlString: String,
        completion: @escaping (String?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(Constant.userAgent, forHTTPHeaderField: "User-Agent")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data,
                  let html = String(data: data, encoding: .utf8)
            else {
                self.logger.log(
                    level: .error,
                    "Error fetching HTML: \(error?.localizedDescription ?? "Unknown")"
                )
                completion(nil)
                return
            }
            completion(html)
        }
        task.resume()
    }
    
}

//
//  HTMLScraper+Wine.swift
//  CorkTale
//
//  Created by hyerim.jin on 2/12/25.
//

import SwiftSoup

extension HTMLScraper {
    
    private enum JSONKeys {
        static let id = "id"
        static let name = "name"
        static let link = "link"
        static let thumb = "thumb"
        static let country = "country"
        static let region = "region"
        static let averageRating = "averageRating"
        static let ratings = "ratings"
        static let price = "price"
    }
    
    private enum Constant {
        static let baseURL = "https://www.vivino.com"
        
        enum Selectors {
            static let wineCard = ".card.card-lg"
            static let wineCardName = ".wine-card__name"
            static let wineCardRegion = ".wine-card__region"
            static let defaultCard = ".default-wine-card"
            static let country = ".wine-card__region [data-item-type=\"country\"]"
            static let region = ".wine-card__region .link-color-alt-grey"
            static let averageRating = ".average__number"
            static let ratings = ".average__stars .text-micro"
            static let price = ".wine-price-value"
            static let link = "a"
            static let thumb = "figure"
        }
        
        enum Regex {
            static let thumbURL = #"url\((.*?)\)"#
        }
    }
    
    public func scrapeWines(from html: String) -> [[String : Any]] {
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let cards = try doc.select(Constant.Selectors.wineCard)
            
            return cards.compactMap { card -> [String : Any]? in
                guard let idRaw = try? card.select(Constant.Selectors.defaultCard).attr("data-vintage").numerize(),
                      let name = try? card.select(Constant.Selectors.wineCardName).text(),
                      let link = try? card.select(Constant.Selectors.link).attr("href"),
                      let country = try? card.select(Constant.Selectors.country).text(),
                      let region = try? card.select(Constant.Selectors.region).text()
                else {
                    return nil
                }
                
                let id = Int(idRaw)
                var thumb: String?
                if let thumbRawValue = try? card.select(Constant.Selectors.thumb).attr("style"),
                   let match = thumbRawValue.range(of: Constant.Regex.thumbURL, options: .regularExpression) {
                    thumb = "https:" + String(thumbRawValue[match].dropFirst(4).dropLast(1))
                }
                
                let averageRating = try? card.select(Constant.Selectors.averageRating).text().numerize()
                let ratingsStr = try? card.select(Constant.Selectors.ratings).text()
                    .replacingOccurrences(of: "ratings", with: "")
                    .trimmingCharacters(in: .whitespaces)
                let ratings = Int(ratingsStr ?? "0")
                let price = try? card.select(Constant.Selectors.price).text().numerize()
                
                var resultDict: [String : Any] = [
                    JSONKeys.id: id,
                    JSONKeys.name: name,
                    JSONKeys.link: "\(Constant.baseURL)\(link)",
                    JSONKeys.country: country,
                    JSONKeys.region: region
                ]
                if let thumb = thumb {
                    resultDict[JSONKeys.thumb] = thumb
                }
                if let averageRating = averageRating {
                    resultDict[JSONKeys.averageRating] = averageRating
                }
                if let ratings = ratings {
                    resultDict[JSONKeys.ratings] = ratings
                }
                if let price = price {
                    resultDict[JSONKeys.price] = price
                }
                
                return resultDict
            }
        } catch {
            self.logger.log(level: .error, "Error parsing HTML: \(error.localizedDescription)")
            return []
        }
    }
    
}

fileprivate extension String {
    
    func numerize() -> Double? {
        let str = self
            .replacingOccurrences(
                of: "[^0-9,.]+",
                with: "",
                options: .regularExpression
            )
            .replacingOccurrences(of: ",", with: ".")
        return Double(str)
    }
    
}

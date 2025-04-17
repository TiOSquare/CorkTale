//
//  APIUtil.swift
//  CorkTale
//
//  Created by Finley on 4/15/25.
//

import Foundation
import UIKit

public class APIUtil {
    public static func toThumbail(_ imageData: Data, size: Int = 100) -> Data {
        let opts = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: size] as CFDictionary
        
        if let imgSrc = CGImageSourceCreateWithData(imageData as NSData, nil),
              let cgImg = CGImageSourceCreateThumbnailAtIndex(imgSrc, 0, opts),
              let thumData = UIImage(cgImage: cgImg).jpegData(compressionQuality: 1.0) {
            return thumData
        }
        
        return imageData
    }

    public static func toJsonData(_ dict: [String: Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        return jsonData
    }
}

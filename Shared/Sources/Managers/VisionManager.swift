//
//  VisionManager.swift
//  Shared
//
//  Created by 홍기웅 on 12/12/24.
//

import Foundation
import Vision
import VisionKit

public class VisionManager: NSObject {
    
    let logger = Log.make(with: .shared)
    
    public func performTextRecognition(cgImage: CGImage?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage else {
            completion(.success(""))
            return
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                self?.logger.log(level: .error, "reqeust fail error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.success(""))
                return
            }
            
            let recognizedText = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            completion(.success(recognizedText))
        }
        
        let revision = VNRecognizeTextRequestRevision3
        request.revision = revision
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        request.usesLanguageCorrection = true
        
        do {
            try handler.perform([request])
        } catch {
            logger.log(level: .error, "handler perform error: \(error)")
            completion(.failure(error))
        }
    }
    
}

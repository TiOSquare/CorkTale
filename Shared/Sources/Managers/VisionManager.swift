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
        let request = createTextRecognitionRequest { result in
            switch result {
            case .success(let recognizedText):
                completion(.success(recognizedText))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        do {
            try handler.perform([request])
        } catch {
            logger.log(level: .error, "handler perform error: \(error)")
            completion(.failure(error))
        }
    }

    private func createTextRecognitionRequest(completion: @escaping (Result<String, Error>) -> Void) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    completion(.success(""))
                    return
                }
                
                let recognizedText = observations
                    .sorted { $0.boundingBox.height > $1.boundingBox.height }
                    .compactMap { $0.topCandidates(1).first?.string }
                    .prefix(3)
                    .joined(separator: "+")
                
                completion(.success(recognizedText))
            }
            
            request.revision = VNRecognizeTextRequestRevision3
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["en-US"]
            request.usesLanguageCorrection = true
            
            return request
    }
    
}

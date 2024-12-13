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
    
    public func recognizeText(cgImage: CGImage) -> String {
        var result = ""
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else { return }
            
            let text = observations.compactMap({ $0.topCandidates(1).first?.string }).joined(separator: "\n")
            result = text
            print("Recognizing text... \(text)")
        }
        
        let revision = VNRecognizeTextRequestRevision3
        request.revision = revision
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en-US"]
        request.usesLanguageCorrection = true
        
        do {
            try handler.perform([request])
        } catch {
            print("Error: \(error)")
        }
        return result
    }
    
}

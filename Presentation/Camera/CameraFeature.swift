//
//  CameraFeature.swift
//  CorkTale
//
//  Created by 홍기웅 on 12/11/24.
//

import ComposableArchitecture
import CoreImage
import Foundation
import Shared

public class CameraFeature: Reducer {
    
    private var cameraManager: CameraManager?
    private let visionManager: VisionManager
    private let previewStreamId: String = "previewStream"
    private let logger = Log.make(with: .presentation)
    
    public init(visionManger: VisionManager) {
        self.visionManager = visionManger
    }
    
    @ObservableState
    public struct State: Equatable {
        var ocrText: String = ""
        var frame: CGImage?
        
        public init() { }
    }
    
    public enum Action: Equatable {
        case ocrButtonDidTap
        case viewDidApear
        case viewDidDisappear
        case updatedFrame(CGImage)
        case updatedOcrLabel(String)
        case dismiss
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {

        switch action {
        case .ocrButtonDidTap:
            logger.log("OCRButton did tapped")
            return detectText(from: state.frame)
            
        case .viewDidApear:
            logger.log("view did Appear")
            return startPreveiwStream()
            
        case .viewDidDisappear:
            logger.log("view did disappear")
            return stopPreviewStream()
            
        case .updatedFrame(let image):
            state.frame = image
            return .none
            
        case .updatedOcrLabel(let text):
            logger.log(level: .debug, "current OCR text: \(text)")
            state.ocrText = text
            return .none
            
        case .dismiss:
            logger.log("dismiss")
            return .none
        }
        

    }
    
    private func detectText(from cgImage: CGImage?) -> Effect<Action> {
        return .run { send in
            self.visionManager.performTextRecognition(cgImage: cgImage) { result in
                Task { @MainActor in
                    switch result {
                    case .success(let text):
                        self.logger.log(level: .notice, "detectText succeeded")
                        send(.updatedOcrLabel(text))
                    case .failure:
                        self.logger.log(level: .error, "detectText failed")
                        send(.updatedOcrLabel(""))
                    }
                }
            }
        }
    }
    
    private func startPreveiwStream() -> Effect<Action> {
        logger.log("start preview stream")
        
        self.cameraManager = .init()
        
        return .run { send in
            if let stream = self.cameraManager?.previewStream {
                for await image in stream {
                    await send(.updatedFrame(image))
                }
            }
        }
        .cancellable(id: previewStreamId, cancelInFlight: true)
    }
    
    private func stopPreviewStream() -> Effect<Action> {
        logger.log("stop preview stream")
        return .cancel(id: previewStreamId)
    }
}

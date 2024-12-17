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
import Combine

public class CameraFeature: Reducer {
    
    private let cameraManager = CameraManager()
    private let visionManager = VisionManager()
    
    public init() { }
    
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
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {

        switch action {
        case .ocrButtonDidTap:
            return detectText(from: state.frame)
            
        case .viewDidApear:
            print("view did apear")
            return startPreveiwStream()
            
        case .viewDidDisappear:
            print("view did disappear")
            return stopPreviewStream()
            
        case .updatedFrame(let image):
            state.frame = image
            return .none
            
        case .updatedOcrLabel(let text):
            state.ocrText = text
            return .none
        }
        

    }
    
    private func detectText(from cgImage: CGImage?) -> Effect<Action> {
        return .run { send in
            self.visionManager.performTextRecognition(cgImage: cgImage) { result in
                Task { @MainActor in
                    switch result {
                    case .success(let text):
                        send(.updatedOcrLabel(text))
                    case .failure:
                        print("실패라 빈 텍스트")
                        send(.updatedOcrLabel(""))
                    }
                }
            }
        }
    }
    
    private func detectText(image: CGImage?) -> String {
        guard let image else { return "" }
        return visionManager.recognizeText(cgImage: image)
    }
    
    private func startPreveiwStream() -> Effect<Action> {
        return .run { send in
            let stream = self.cameraManager.previewStream
            for await image in stream {
                await send(.updatedFrame(image))
            }
        }
        .cancellable(id: "previewStream", cancelInFlight: true)
    }
    
    private func stopPreviewStream() -> Effect<Action> {
        return .cancel(id: "PreviewStream")
    }
}

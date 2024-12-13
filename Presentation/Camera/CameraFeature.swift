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
    private var previewStreamTask: Task<Void, Never>?
    
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
    }
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {

        switch action {
        case .ocrButtonDidTap:
            print("ocrButton did tap")
            let currentFrame = state.frame
            state.ocrText = self.detectText(image: currentFrame)
            return .none
            
        case .viewDidApear:
            print("view did apear")
            return initializeFeature()
            
        case .viewDidDisappear:
            print("view did disappear")
            return releaseFeature()
            
        case .updatedFrame(let image):
            state.frame = image
            return .none
            
        }

    }
    
    private func detectText(image: CGImage?) -> String {
        guard let image else { return "" }
        return visionManager.recognizeText(cgImage: image)
    }
    
    private func initializeFeature() -> Effect<Action> {
        return .run { send in
            self.previewStreamTask = Task {
                for await image in self.cameraManager.previewStream {
                    Task { @MainActor in
                        send(.updatedFrame(image))
                    }
                }
            }
        }
    }
    
    private func releaseFeature() -> Effect<Action> {
        if self.previewStreamTask != nil {
            self.previewStreamTask?.cancel()
        }
        
        return .none
    }
}

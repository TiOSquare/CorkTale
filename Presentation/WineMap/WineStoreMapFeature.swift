//
//  WineMapFeature.swift
//  Presentation
//
//  Created by 홍기웅 on 1/20/25.
//

import Foundation
import ComposableArchitecture
import Shared
import Domain

public class WineStoreMapFeature: Reducer {
    
    private let logger = Log.make(with: .presentation)
    
    private var useCase: LocationUseCase
    
    private var latestCameraHeading: Double = 0.0
    private var latestUserHeading: Double = 0.0
    
    public init(useCase: LocationUseCase) {
        self.useCase = useCase
    }
    
    @ObservableState
    public struct State: Equatable {
        var currentLatitude: Double = 0.0
        var currentLongitude: Double = 0.0
        var currentHeading: Double = 0.0

        public init() { }
    }
    
    @CasePathable
    public enum Action: Equatable {
        
        case viewDidApear
        case viewDidDisappear
        case viewCameraHeadingDidChange(Double)
        case updateCurrentCoordinate(Double, Double)
        case updateCurrentHeading(Double, Double)
    }
    
    public var body: some ReducerOf<WineStoreMapFeature> {
        Reduce { state, action in
            switch action {
                
            case .viewDidApear:
                self.logger.log("view did appear")
                return self.initializeUI()
                
            case .viewDidDisappear:
                self.logger.log("view did disappear")
                return .none
                
            case .updateCurrentCoordinate(let latitude, let longitude):
                self.logger.log(level: .info, "update current coordinate. latitude: \(latitude), longitude: \(longitude)")
                state.currentLatitude = latitude
                state.currentLongitude = longitude
                return .none
                
            case .updateCurrentHeading(let userHeading, let cameraHeading):
                state.currentHeading = self.calculateCurrentHeading(userHeading, cameraHeading)
                return .none
                
            case .viewCameraHeadingDidChange(let cameraHeading):
                self.latestCameraHeading = cameraHeading
                return .send(.updateCurrentHeading(self.latestUserHeading, cameraHeading))
            }
        }
    }
    
    
    private func initializeUI() -> Effect<Action> {
        
        return .merge(
            .run(operation: { send in
                let stream = self.useCase.startLocationStream()
                for await location in stream {
                    await send(.updateCurrentCoordinate(location.coordinate.latitude, location.coordinate.longitude))
                }
                
            }),
            .run(operation: { send in
                let stream = self.useCase.startHeadingStream()
                for await userHeading in stream {
                    self.latestUserHeading = userHeading.trueHeading
                    await send(.updateCurrentHeading(userHeading.trueHeading, self.latestCameraHeading))
                }
            }),
            .none
        )
    }
    
    private func deinitialize() -> Effect<Action> {
        
        useCase.stopLocationStream()
        useCase.stopHeadingStream()
        
        return .none
    }
}

private extension WineStoreMapFeature {
    
    func calculateCurrentHeading(_ userHeading: Double, _ cameraHeading: Double) -> Double {
        return userHeading - cameraHeading
    }
    
}

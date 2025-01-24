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
        case updateCurrentCoordinate(Double, Double)
        case updateCurrentHeading(Double)
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
                
            case .updateCurrentHeading(let currentHeading):
                state.currentHeading = currentHeading
                return .none
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
                for await heading in stream {
                    await send(.updateCurrentHeading(heading.trueHeading))
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

//
//  StoreFactoryImpl.swift
//  App
//
//  Created by 홍기웅 on 3/13/25.
//

import ComposableArchitecture
import Foundation
import Presentation
import Data
import Domain
import Shared

final class StoreFactoryImpl: StoreFactory {
    
    func makeWineSearchFeatureStore() -> StoreOf<WineSearchFeature> {
        
        let visionManager = VisionManager()
        let cameraFeature = CameraFeature(visionManger: visionManager)
        let wineRepository = WineRepositoryImpl()
        let wineUsecase = WineUseCaseImpl(repository: wineRepository)
        
        return .init(
            initialState: WineSearchFeature.State(),
            reducer: {
                WineSearchFeature(cameraFeature: cameraFeature, usecase: wineUsecase)
            }
        )
    }
    
    func makeWineStoreMapFeatureStore() -> StoreOf<WineStoreMapFeature> {
        let locationUsecase = LocationUseCaseImpl()
        
        return .init(
            initialState: WineStoreMapFeature.State(),
            reducer: {
                WineStoreMapFeature(useCase: locationUsecase)
            }
        )
    }
    
    func makeHelloFeatureStore() -> StoreOf<HelloFeature> {
        let helloRepository = HelloRepositoryImpl()
        
        return .init(
            initialState: HelloFeature.State(),
            reducer: {
                HelloFeature(helloRepository: helloRepository)
            }
        )
    }
    
}

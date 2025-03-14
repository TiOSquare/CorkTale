//
//  StoreFactory.swift
//  Presentation
//
//  Created by 홍기웅 on 3/13/25.
//

import Foundation
import ComposableArchitecture


public protocol StoreFactory {
    func makeWineSearchFeatureStore() -> StoreOf<WineSearchFeature>
    func makeWineStoreMapFeatureStore() -> StoreOf<WineStoreMapFeature>
    func makeHelloFeatureStore() -> StoreOf<HelloFeature>
}

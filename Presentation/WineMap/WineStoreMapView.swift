//
//  WineStoreMapView.swift
//  Presentation
//
//  Created by 홍기웅 on 1/20/25.
//

import SwiftUI
import MapKit
import ComposableArchitecture
import Shared

@available(iOS 17.0, *)
public struct WineStoreMapView: View {
    
    let store: StoreOf<WineStoreMapFeature>
    
    public init(factory: StoreFactory) {
        self.store = factory.makeWineStoreMapFeatureStore()
    }
    
    public var body: some View {
        Map(content: {
            Annotation("currentHeading:\(store.currentHeading)",
                       coordinate: .init(latitude: store.currentLatitude, longitude: store.currentLongitude),
                       content: {
                ZStack {
                    Image(systemName: "inset.filled.circle")
                        .padding(15)
                    
                    VStack {
                        Image(systemName: "wave.3.up")
                        Spacer()
                    }
                }
                .foregroundStyle(Color.pink)
                .rotationEffect(Angle(degrees: store.currentHeading))
                
            })
            
        })
        .mapControlVisibility(.hidden)
        .onMapCameraChange({ cameraContext in
            store.send(.viewCameraHeadingDidChange(cameraContext.camera.heading))
        })
        .onAppear {
            store.send(.viewDidApear)
        }
        .onDisappear {
            store.send(.viewDidDisappear)
        }
    }
}



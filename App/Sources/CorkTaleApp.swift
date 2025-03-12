import SwiftUI
import ComposableArchitecture
import Presentation
import Domain

@main
struct CorkTaleApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            CameraView(store: .init(initialState: CameraFeature.State(), reducer: { CameraFeature() } ))
//            WineSearchView(store: .init(initialState: WineSearchFeature.State(), reducer: { WineSearchFeature() } ))
            WineStoreMapView(store: .init(initialState: WineStoreMapFeature.State(),
                                          reducer: { WineStoreMapFeature(useCase: LocationUseCaseImpl()) } ))
        }
    }
}
 

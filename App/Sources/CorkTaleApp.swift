import SwiftUI

@main
struct CorkTaleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: AppFeature.State(), reducer: {
                AppFeature()
            }))
        }
    }
}
 

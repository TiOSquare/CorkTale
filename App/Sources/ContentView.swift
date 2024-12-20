import SwiftUI
import ComposableArchitecture
import Presentation

public struct ContentView: View {

    public var body: some View {
        MainView(store: .init(initialState: MainFeature.State(), reducer: {
            MainFeature()
        }))
    }
}

enum Tab: Hashable {
    case home, location, search, profile, music
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

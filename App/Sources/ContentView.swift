import SwiftUI
import ComposableArchitecture
import Presentation

public struct ContentView: View {

    let factory = StoreFactoryImpl()
    
    public var body: some View {
        MainView(factory: factory)
    }
}

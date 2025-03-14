//
//  HelloView.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/24/24.
//

import SwiftUI

import ComposableArchitecture

import Domain


public struct HelloView: View {
    
    private let store: StoreOf<HelloFeature>
    
    public init(factory: StoreFactory) {
        
        self.store = factory.makeHelloFeatureStore()
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("""
                hello
                \(self.store.helloText)
                ----
                helloID
                \(self.store.helloIDText)
                ----
                helloUser
                \(self.store.helloUser?.description ?? "")
                """)
            
            VStack(spacing: 10) {
                ItemView(
                    text: "hello",
                    request: { self.store.send(.requestHello) }
                )
                
                ItemView(
                    text: "helloID",
                    request: { self.store.send(.requestHelloID) }
                )
                
                ItemView(
                    text: "helloUser",
                    request: { self.store.send(.requestHelloUser) }
                )
            }
            .frame(width: 250)
        }
        .padding()
        .onAppear {
            self.store.send(.viewWillAppear)
        }
    }
}

extension HelloView {
    fileprivate struct ItemView: View {
        let text: String
        let request: () -> (Void)
        
        var body: some View {
            HStack {
                Text(text)
                Spacer()
                Button(
                    action: request,
                    label: { Text("Request") }
                )
            }
        }
    }
}

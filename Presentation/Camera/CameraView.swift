//
//  CameraView.swift
//  CorkTale
//
//  Created by 홍기웅 on 12/11/24.
//

import ComposableArchitecture
import SwiftUI

public struct CameraView: View {
    
    // MARK: - Variables
    
    let store: StoreOf<CameraFeature>
    
    public init(store: StoreOf<CameraFeature>) {
        self.store = store
    }
    
    // MARK: - UI Components
    
    private var ocrLabel: Text {
        Text(store.ocrText)
    }
    
    private var ocrButton: some View {
        Button(action: {
            store.send(.ocrButtonDidTap)
            
        }, label: {
            Text("get text")
                .tint(.red)
        })
    }
    
    private var frame: some View {
            
            GeometryReader { geometry in
                if let image = store.frame {
                    Image(decorative: image, scale: 1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                }
            }
            
    }
    
    // MARK: - View Body
    
    public var body: some View {
        WithPerceptionTracking {
            
            ZStack {
                frame
                
                VStack {
                    ocrLabel
                    
                    Spacer()
                    
                    ocrButton
                        .padding()
                }
            }
            .onAppear {
                store.send(.viewDidApear)
            }
            .onDisappear {
                store.send(.viewDidDisappear)
            }
            
        }
    }
    
}


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
    
    // MARK: - CameraView Body
    
    public var body: some View {
        WithPerceptionTracking {
            
            ZStack {
                Preview(frame: store.frame)
                
                VStack {
                    OCRLabel(text: store.ocrText)
                    Spacer()
                    OCRButton(action: {
                        store.send(.ocrButtonDidTap)
                    })
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
    
// MARK: - UI Components

extension CameraView {
    
    private struct OCRLabel: View {
        
        var text: String = ""
        
        var body: some View {
            Text(text)
                .font(.largeTitle)
                .padding()
        }
    }
    
    private struct OCRButton: View {
        let action: () -> Void
        
        var body: some View {
            Button(action: action, label: {
                Text("get text")
                    .tint(.red)
            })
        }
    }
    
    private struct Preview: View {
        
        var frame: CGImage?
        
        var body: some View {
            GeometryReader { geometry in
                if let image = self.frame {
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
    }
    
}


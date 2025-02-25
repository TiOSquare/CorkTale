//
//  SearchFeature.swift
//  Presentation
//
//  Created by 홍기웅 on 1/13/25.
//

import Foundation
import ComposableArchitecture
import Domain
import Shared
import Data // tempo

public class WineSearchFeature: Reducer {
    
    private let logger = Log.make(with: .presentation)
    private let cameraFeature = CameraFeature()
    private let usecase: WineUseCase = WineUseCaseImpl(repository: WineRepositoryImpl())
    
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        var searchText: String = ""
        var searchResult: [Wine] = []
        var isPresentedCameraSheet: Bool = false
        var cameraState = CameraFeature.State()
        
        public init() { }
    }
    
    @CasePathable
    public enum Action: Equatable, BindableAction {
        
        case viewDidApear
        case viewDidDisappear
        case searchButtonDidTapped
        case cameraButtonDidTapped
        case updateSearchResult([Wine])
        case binding(BindingAction<State>)
        case cameraAction(CameraFeature.Action)
        
    }
    
    public var body: some ReducerOf<WineSearchFeature> {
        BindingReducer()
        Scope(state: \.cameraState, action: \.cameraAction) {
            cameraFeature
        }
        Reduce { state, action in
            switch action {
                
            case .viewDidApear:
                self.logger.log("view did appear")
                return .none
                
            case .viewDidDisappear:
                self.logger.log("view did disappear")
                return .none
                
            case .searchButtonDidTapped:
                self.logger.log("search button did tapped")
                return self.requestSearchWines(with: state.searchText)
                
            case .cameraButtonDidTapped:
                self.logger.log("camera button did tapped")
                state.isPresentedCameraSheet = true
                return .none
                
            case .updateSearchResult(let wineList):
                state.searchResult = wineList
                self.logger.log("result: \(state.searchResult)")
                return .none
                
            // Binding
                
            case .binding(\.searchText):
                self.logger.log("changedSearchText: \(state.searchText)")
                return .none
                
            case .binding(\.isPresentedCameraSheet):
                self.logger.log("isPresentedCameraSheet: \(state.isPresentedCameraSheet)")
                return .none
                
            case .binding:
                return .none
               
            // Child Feature Action
            
            case .cameraAction(.updatedOcrLabel(let text)):
                self.logger.log("from camera feature: \(text)")
                state.isPresentedCameraSheet = false
                return .none
                
            case .cameraAction(.dismiss):
                state.isPresentedCameraSheet = false
                return .none
                
            case .cameraAction:
                return .none
            }
        }
    }
    
}

private extension WineSearchFeature {
    func requestSearchWines(with text: String) -> Effect<Action> {
        
        return .run(operation: { send in
            let result = try? await self.usecase.search(name: text)
            await send(.updateSearchResult(result ?? []))
        })
    }
    
}

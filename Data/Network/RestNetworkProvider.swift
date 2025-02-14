//
//  RestNetworkProvider.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/23/24.
//

import Combine
import Foundation

import CombineMoya
import Moya

protocol NetworkProvider {
    func request<T: TargetType, U: Decodable>(_ target: T) async throws -> RestResponse<U>
}

final class RestNetworkProvider: MoyaProvider<MultiTarget> {
    
    private enum Constant {
        static let timeoutIntervalForRequest: TimeInterval = 60
    }
    
    init(plugins: [PluginType] = []) {
#if DEBUG
        let allPlugins: [PluginType] = plugins
        + [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
#else
        let allPlugins: [PluginType] = plugins
#endif
        
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = Constant.timeoutIntervalForRequest

        let session = Session(
            configuration: configuration,
            startRequestsImmediately: false
        )
        super.init(session: session, plugins: allPlugins)
    }
}

extension RestNetworkProvider: NetworkProvider {
    func request<T: TargetType, U: Decodable>(
        _ target: T
    ) async throws -> RestResponse<U> {
        try await self.requestPublisher(MultiTarget(target))
            .map(RestResponse<U>.self)
            .async()
    }
}

fileprivate extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}

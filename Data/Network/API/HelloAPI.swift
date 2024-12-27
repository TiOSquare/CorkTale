//
//  HelloAPI.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/23/24.
//

import Foundation

import Moya

import Shared

enum HelloAPI {
    case hello
    case helloWithID(String)
    case helloUser(String, String)
}

extension HelloAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constant.Network.baseURL + "/hello")!
    }
    
    var method: Moya.Method {
        switch self {
        case .hello, .helloWithID, .helloUser:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .hello: 
            return ""
        case .helloWithID(let id):
            return "/\(id)"
        case .helloUser:
            return "/user"
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": Constant.Network.reqHeaderAccept]
    }
    
    var task: Task {
        var params: [String : Any] = [:]
        
        switch self {
        case .hello:
            return .requestPlain
            
        case .helloWithID:
            return .requestPlain
            
        case .helloUser(let id, let name):
            params["id"] = id
            params["name"] = name
        }
        
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.default
        )
    }
    
    var sampleData: Data {
        return Data()
    }
    
}



//
//  ProfileAPI.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//

import Foundation
import Moya
import Shared

enum ProfileAPI {
    case createProfile(String, String, Int, String, [String])
    case getAllProfile
    case getNickname
    case getProfileImage
    case getLevel
    case getNationality
}

extension ProfileAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constant.Network.baseURL + "/users")!
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllProfile, .getNickname, .getProfileImage, .getLevel, .getNationality:
            return .get
        case .createProfile:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createProfile:
            return "/users"
        case .getAllProfile:
            return "/users"
        case .getNickname:
            return "/users/nickname"
        case .getProfileImage:
            return "/users/profileImage"
        case .getLevel:
            return "/users/level"
        case .getNationality:
            return "/users/nationality"
        }
    }
    
    var headers: [String : String]? {
//        return ["Accept": Constant.Network.reqHeaderAccept]
        return defaultHeaders
    }
    
    var task: Task {
        var params: [String : Any] = [:]
        
        switch self {
        case .createProfile(let nickname, let profileImage, let level, let nationality, let emblem):
            params["nickname"] = nickname
            params["profileImage"] = profileImage
            params["level"] = level
            params["nationality"] = nationality
            params["emblem"] = emblem
            
        case .getAllProfile:
            return .requestPlain
        case .getNickname:
            return .requestPlain
        case .getProfileImage:
            return .requestPlain
        case .getLevel:
            return .requestPlain
        case .getNationality:
            return .requestPlain
        }
        
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.default
        )
    }
    
    var sampleData: Data {
        return Data()
    }
    
    private var defaultHeaders: [String: String] {
        return [
            "id": "hello",
            "Content-Type": "application/json",
            "Accept-Encoding": "gzip"
        ]
    }
}



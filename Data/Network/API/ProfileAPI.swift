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
    case createProfile(ProfileDTO)
    case getAllProfile
    case updateProfile(ProfileEditDTO)
}

extension ProfileAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Constant.Network.baseURL + "/users")!
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllProfile:
            return .get
        case .createProfile:
            return .post
        case .updateProfile:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createProfile:
            return ""
        case .getAllProfile:
            return ""
        case .updateProfile:
            return "/edit"
        }
    }
    
    var headers: [String : String]? {
        return defaultHeaders
    }
    
    var task: Task {
        switch self {
        case .createProfile(let dto):
            return .requestJSONEncodable(dto)
        case .getAllProfile:
            return .requestPlain
        case .updateProfile(let dto):
            return .requestJSONEncodable(dto)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    private var defaultHeaders: [String: String] {
        return [
            "id": "hello"
        ]
    }
}



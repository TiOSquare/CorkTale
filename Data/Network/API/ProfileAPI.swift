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
        }
    }
    
    var path: String {
        switch self {
        case .createProfile:
            return ""
        case .getAllProfile:
            return ""
        }
    }
    
    var headers: [String : String]? {
        return defaultHeaders
    }
    
    var task: Task {
        switch self {
        case .createProfile(let nickname, let profileImage, let level, let nationality, let emblem):
            let dto = ProfileDTO(nickname: nickname,
                                 profileImage: profileImage,
                                 level: level,
                                 nationality: nationality,
                                 emblem: emblem)
            if let jsonData = try? JSONEncoder().encode(dto),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return .requestParameters(parameters: jsonObject, encoding: JSONEncoding.default)
            } else {
                return .requestPlain
            }
        case .getAllProfile:
            return .requestPlain
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



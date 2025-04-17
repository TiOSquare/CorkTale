//
//  ProfileAPI.swift
//  CorkTale
//
//  Created by Finley on 1/22/25.
//

import Foundation
import UIKit

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
            return .patch
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
    
    private var multipartformHeaders: [String: String] {
        return [
            "Content-Type": "multipart/form-data",
            "id": "hello"
        ]
    }
    
    private func multipartFormData(dict: [String: Any], image: UIImage, imageName: String, needsThumbnail: Bool) -> [MultipartFormData]? {
        if let metaData = try? JSONSerialization.data(withJSONObject: dict, options: []),
           let imageData = image.jpegData(compressionQuality: 0.8) {
            var formData: [MultipartFormData] =
            [MultipartFormData(provider: .data(metaData), name: "meta-data"),
             MultipartFormData(provider: .data(imageData), name: "image")]
            if needsThumbnail {
                let thumbData = APIUtil.toThumbail(imageData)
                formData.append(MultipartFormData(provider: .data(thumbData), name: "thumbnail"))
            }
            return formData
        } else {
            return nil
        }
    }
}



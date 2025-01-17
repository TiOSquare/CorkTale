//
//  RestResponse.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/24/24.
//

struct RestResponse<T: Decodable>: Decodable {
    let resultCode: Int
    let resultMsg: String?
    let data: T?
}

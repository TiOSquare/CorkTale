//
//  Constant.swift
//  CorkTale
//
//  Created by hyerim.jin on 12/27/24.
//

import Foundation

public enum Constant {
    public enum Network {
        public static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
        public static let reqHeaderAccept = "application/json"
    }
}

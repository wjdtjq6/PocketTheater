//
//  TmdbRouter.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/9/24.
//

import Foundation

enum Header: String {
    case Authorization = "Authorization"
    case accept = "application/json"
}

enum TmdbRouter: String {
    case search
    case trending
    case similar
    case cast
    case genre
    
//    var baseURL: String {
//        return APIKey.baseURL
//    }
//    
//    var path: String {
//        
//    }
//    
//    var queryItems: [URLQueryItem]? {
//        
//    }
//    
//    var body: Data? { ... }
//    
//    var headers: [String: String] { ... }
//
//    // 새로운 프로퍼티 추가
//    var parameters: [String: Any]? {
//        // 각 case에 따른 파라미터 반환
//        switch self {
//        case .login(let query):
//            return query.dictionary
//        // 다른 case들...
//        default:
//            return nil
//        }
//    }
    
}

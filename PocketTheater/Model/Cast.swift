//
//  Cast.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/9/24.
//

import Foundation

struct Cast: Decodable {
    let id: Int
    let cast: [Casts]
    let crew: [Crews]
}

struct Casts: Decodable {
    let adult: Bool
    let id: Int
    let name: String
    let castID: Int
    let character: String
    let creditID: String
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case adult, id, name, character, order
        case castID = "cast_id"
        case creditID = "credit_id"
    }
}

struct Crews: Decodable {
    let name: String
}

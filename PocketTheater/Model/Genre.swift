//
//  Search.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/9/24.
//

import Foundation

struct Genre: Decodable {
    let genres: [Genres]
}

struct Genres: Decodable {
    let id: Int
    let name: String
}

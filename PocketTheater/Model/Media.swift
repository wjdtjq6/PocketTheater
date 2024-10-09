//
//  Media.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/9/24.
//

import Foundation

struct Media: Decodable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Result: Decodable {
    let backdropPath: String?
    let id: Int
    let name: String?
    let title: String?
    let overview: String
    let posterPath: String?
    let adult: Bool
    let genreIDS: [Int]
    let firstAirDate: String?
    let releaseDate: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, overview, adult, name, title
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case genreIDS = "genre_ids"
        case firstAirDate = "first_air_date"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

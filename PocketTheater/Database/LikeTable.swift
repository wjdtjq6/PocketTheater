//
//  LikeTable.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import RealmSwift

class Like: Object {
    
    @Persisted(primaryKey: true) var id: Int    /// TMDB ID
    @Persisted var createAt: Date               /// 좋아요한 날짜
    @Persisted var title: String                /// 영화/드라마 이름
    @Persisted var imagePath: String            /// 대표 이미지 (FileManager)
    
    convenience init(media: Result, imagePath: String) {
        self.init()
        self.id = media.id
        self.createAt = Date()
        self.title = media.title ?? media.name ?? "Untitled"
        self.imagePath = imagePath
    }
    
}

/// `Model이랑 중복되기 때문에 추후 지우세요!`
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

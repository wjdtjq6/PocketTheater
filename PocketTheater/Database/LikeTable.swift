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

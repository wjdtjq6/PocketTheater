//
//  LikeRepository.swift
//  PocketTheater
//
//  Created by junehee on 10/11/24.
//

import Foundation
import RealmSwift

final class LikeRepository {
    
    private let realm = try! Realm()
    
    // 찜한 사진 전체 불러오기
    func getAllLikeMedia() -> Results<Like> {
        return realm.objects(Like.self)
    }
    
    func getAllLikeMedia() -> [Like]? {
        let likeMedia = realm.objects(Like.self)
        return Array(likeMedia)
    }
    
    // 스키마버전 확인
    private func getSchemaVersion() {
        print(realm.configuration.schemaVersion)
    }

    // 저장 경로 확인
    private func getFileURL() {
        print(realm.configuration.fileURL ?? "No fileURL")
        
    }
    
}

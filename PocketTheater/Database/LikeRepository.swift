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
    
    // 찜한 사진 불러오기 (단일)
    func getLikeMedia(id: Int) -> Like? {
        return realm.object(ofType: Like.self, forPrimaryKey: id)
    }
    
    // 찜한 미디어 추가하기
    func addLikeMedia(_ media: Like) throws {
        do {
            try realm.write {
                realm.add(media)
                print("Succeed Add LikeMedia")
            }
        } catch {
            print("Failed Add LikeMedia", error)
            throw error
        }
    }
    
    // 찜한 사진 삭제하기
    func deleteLikeMedia(media: Like) {
        do {
            try realm.write {
                realm.delete(media)
                print("Succeed Delete LikeMedia")
            }
        } catch {
            print("Failed Delete LikeMedia", error)
        }
    }
    
    // 스키마버전 확인
    func getSchemaVersion() {
        print(realm.configuration.schemaVersion)
    }

    // 저장 경로 확인
    func getFileURL() {
        print(realm.configuration.fileURL ?? "No fileURL")
        
    }
    
}

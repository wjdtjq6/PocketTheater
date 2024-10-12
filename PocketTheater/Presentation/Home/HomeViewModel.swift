//
//  HomeViewModel.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/10/24.
//

import RxDataSources
import RxSwift
import RxCocoa

struct MediaItem {
    let id: Int
    let posterPath: String
}

struct MediaSection {
    var header: String
    var items: [MediaItem]
}

extension MediaSection: SectionModelType {
    typealias Item = MediaItem
    
    init(original: MediaSection, items: [MediaItem]) {
        self = original
        self.items = items
    }
}

class HomeViewModel {
    let sections: BehaviorRelay<[MediaSection]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()
    
    init() async throws {
        fetchTrendingMedia() // 비동기 호출을 이곳에서 처리하지 않도록 수정
    }
    
    func loadImage(for item: MediaItem) -> Observable<Any?> {
        return Observable.create { observer in
            Task {
                do {
                    let imageData = try await NetworkManager.shared.fetchImage(imagePath: item.posterPath)
                    observer.onNext(imageData)
                    observer.onCompleted()
                } catch {
                    print("이미지 로드 오류: \(error)")
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    private func fetchTrendingMedia() {
        Single<Media>.create { single in
            Task {
                do {
                    let movieMedia = try await NetworkManager.shared.fetchTrending(mediaType: .movie)
                    single(.success(movieMedia))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
        .flatMap { movieMedia -> Single<(Media, Media)> in
            Single<Media>.create { single in
                Task {
                    do {
                        let tvMedia = try await NetworkManager.shared.fetchTrending(mediaType: .tv)
                        single(.success(tvMedia))
                    } catch {
                        single(.failure(error))
                    }
                }
                return Disposables.create()
            }
            .map { tvMedia in
                return (movieMedia, tvMedia)
            }
        }
        .map { movieMedia, tvMedia in
            let movieItems = movieMedia.results.map { MediaItem(id: $0.id, posterPath: $0.posterPath ?? "") }
            let tvItems = tvMedia.results.map { MediaItem(id: $0.id, posterPath: $0.posterPath ?? "") }
           
            // Create featured items from the first 5 movie items
            let featuredItems = Array(movieItems.prefix(5))
            
            return [
                MediaSection(header: "Featured", items: featuredItems),
                MediaSection(header: "지금 뜨는 영화", items: movieItems),
                MediaSection(header: "지금 뜨는 TV 시리즈", items: tvItems)
            ]
        }
        .asObservable()
        .bind(to: sections)
        .disposed(by: disposeBag)
    }

}

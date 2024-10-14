//
//  HomeViewModel.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct HomeMediaSection {
    var header: String
    var items: [Result]
}

extension HomeMediaSection: SectionModelType {
    typealias Item = Result
    
    init(original: HomeMediaSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class HomeViewModel {
    private let disposeBag = DisposeBag()
    private let genreRepository: GenreRepository
    private var genreCache: [MediaType: [Genres]] = [:]
    
    init(genreRepository: GenreRepository = GenreRepository()) {
        self.genreRepository = genreRepository
    }
    
    struct Input {
        let loadTrigger: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<[HomeMediaSection]>
        let isLoading: Driver<Bool>
        let error: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let loadingRelay = BehaviorRelay<Bool>(value: false)
        let errorRelay = PublishRelay<String>()
        
        let sections = input.loadTrigger
            .do(onNext: { loadingRelay.accept(true) })
            .flatMapLatest { [weak self] _ -> Observable<[HomeMediaSection]> in
                guard let self = self else { return .empty() }
                return self.fetchTrendingMedia()
                    .do(
                        onNext: { _ in loadingRelay.accept(false) },
                        onError: { error in
                            loadingRelay.accept(false)
                            errorRelay.accept(error.localizedDescription)
                        }
                    )
                    .catch { error in
                        print("Error fetching media: \(error)")
                        return .just([])
                    }
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            sections: sections,
            isLoading: loadingRelay.asDriver(),
            error: errorRelay.asDriver(onErrorJustReturn: "Unknown error occurred")
        )
    }
    
    func fetchGenre(for mediaItem: Result) -> Observable<String> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            Task {
                do {
                    let mediaType = self.determineMediaType(from: mediaItem)
                    print("Determined media type: \(mediaType)") // 디버그 로그
                    
                    let genres = try await self.getGenres(for: mediaType)
                    print("Fetched genres: \(genres)") // 디버그 로그
                    
                    let mediaGenres = mediaItem.genreIDS.compactMap { genreId in
                        genres.first { $0.id == genreId }?.name
                    }
                    print("Media genres: \(mediaGenres)") // 디버그 로그
                    
                    let genreString = mediaGenres.isEmpty ? "Unknown" : mediaGenres.joined(separator: ", ")
                    print("Genre string: \(genreString)") // 디버그 로그
                    
                    observer.onNext(genreString)
                    observer.onCompleted()
                } catch {
                    print("Error fetching genre: \(error)") // 디버그 로그
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func determineMediaType(from result: Result) -> MediaType {
        if result.firstAirDate != nil {
            return .tv
        } else if result.releaseDate != nil {
            return .movie
        } else {
            return .movie
        }
    }
        
    private func getGenres(for mediaType: MediaType) async throws -> [Genres] {
        if let cachedGenres = genreCache[mediaType] {
            return cachedGenres
        }
        
        let genres = try await genreRepository.fetchGenres(for: mediaType)
        genreCache[mediaType] = genres
        return genres
    }
    
    private func fetchTrendingMedia() -> Observable<[HomeMediaSection]> {
        Observable.zip(
            fetchTrending(mediaType: .movie),
            fetchTrending(mediaType: .tv)
        )
        .map { movieMedia, tvMedia in
            let featuredItem = movieMedia.results.randomElement()
            return [
                HomeMediaSection(header: "Featured", items: featuredItem.map { [$0] } ?? []),
                HomeMediaSection(header: "지금 뜨는 영화", items: movieMedia.results),
                HomeMediaSection(header: "지금 뜨는 TV 시리즈", items: tvMedia.results)
            ]
        }
    }
    
    private func fetchTrending(mediaType: MediaType) -> Observable<Media> {
        return Observable.create { observer in
            Task {
                do {
                    let media = try await NetworkManager.shared.fetchTrending(mediaType: mediaType)
                    observer.onNext(media)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func loadImage(for item: Result) -> Observable<Data?> {
        Observable.create { observer in
            Task {
                do {
                    let imageData = try await NetworkManager.shared.fetchImage(imagePath: item.posterPath ?? "")
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
}

class GenreRepository {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchGenres(for mediaType: MediaType) async throws -> [Genres] {
        let genreResponse = try await networkManager.fetchGenre(mediaType: mediaType)
        return genreResponse.genres
    }
}

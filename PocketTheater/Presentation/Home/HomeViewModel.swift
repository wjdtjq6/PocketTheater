//
//  HomeViewModel.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/10/24.
//

<<<<<<< HEAD
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
=======
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
>>>>>>> ddcc5a5eb0b761f4e0bc0b12cc508d4d47332407
        self = original
        self.items = items
    }
}

class HomeViewModel {
<<<<<<< HEAD
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
            // 기본값으로 movie를 반환하거나,
            // 적절한 에러 처리를 할 수 있습니다.
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
=======
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
>>>>>>> ddcc5a5eb0b761f4e0bc0b12cc508d4d47332407
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
<<<<<<< HEAD
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
=======
    
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

>>>>>>> ddcc5a5eb0b761f4e0bc0b12cc508d4d47332407
}

//
//  SearchViewModel.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

//final class SearchViewModel: ViewModelType {
//    
//    private let disposeBag = DisposeBag()
//    private let networkMAnager = NetworkManager.shared
//    
//    // 추천 시리즈 & 영화
//    private var recommendedItems: [MediaItem] = []
//    // 검색 결과
//    private var searchResults: [MediaItem] = []
//    
//    // 현재 표시할 아이템들
//    private var currentItems = BehaviorRelay<[MediaItem]>(value: [])
//    
//    // 검색어
//    private let searchQuery = BehaviorRelay<String>(value: "")
//    struct Input {
//        let searchText: ControlProperty<String>
//        let itemSelected: ControlEvent<IndexPath>
//
//    }
//    
//    struct Output {
//        let searchMediaResults: Driver<[MediaItem]>
////        let recomandMediaResults: BehaviorSubject<[Media]>
//    }
//    
//   
//    func transform(input: Input) -> Output {
//        let searchResults = input.searchText
//            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
//            .flatMapLatest { [weak self] query -> Observable<[MediaItem]> in
//                guard let self = self else { return .empty() }
//                return self.searchMedia(query: query)
//            }
//            .asDriver(onErrorJustReturn: [])
//        
//        input.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                self?.selectedMedia(at: indexPath)
//            })
//            .disposed(by: disposeBag)
//        
//        return Output(searchMediaResults: searchResults)
//    }
//    
//    private func searchMedia(query: String) -> Observable<[MediaItem]> {
//        return .just([
//            MediaItem(title: "\(query) 결과 1", imageUrl: nil),
//            MediaItem(title: "\(query) 결과 2", imageUrl: nil),
//            MediaItem(title: "\(query) 결과 3", imageUrl: nil)
//        ])
//    }
//    
//    private func selectedMedia(at indexPath: IndexPath) {
//        // 선택된 아이템 처리 로직
//        print("선택된 아이템: \(indexPath)")
//    }
//}

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    
    private let trendingMedia = BehaviorRelay<[MediaItem]>(value: [])
    private let searchMedia = BehaviorRelay<[MediaItem]>(value: [])
    private let goToDetail = PublishSubject<Int>()
    struct Input {
        let searchText: ControlProperty<String>
        let itemSelected: ControlEvent<IndexPath>
    }
    
    struct Output {
        let mediaResults: Driver<[MediaSection]>
//        let gotoDetail: Observable<Int>
    }
    
    init() {
        fetchTrendingMedia()
    }
    
    func transform(input: Input) -> Output {
        let searchResults = input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { [weak self] query -> Observable<[MediaItem]> in
                guard let self = self, !query.isEmpty else {
                    return .just([])
                }
                return self.searchMedia(query: query)
            }
            .share()
        
        searchResults
            .bind(to: self.searchMedia)
            .disposed(by: disposeBag)
        
        let mediaResults = Observable.combineLatest(trendingMedia, searchMedia) { trending, search in
            if search.isEmpty {
                return [MediaSection(model: "추천 시리즈 & 영화", items: trending)]
            } else {
                return [MediaSection(model: "영화 & 시리즈", items: search)]
            }
        }
        
        input.itemSelected
            .withLatestFrom(mediaResults) { indexPath, sections in
                return sections[indexPath.section].items[indexPath.item]
            }
            .subscribe(onNext: { [weak self] item in
                self?.selectedMedia(item)
            })
            .disposed(by: disposeBag)
        
        return Output(mediaResults: mediaResults.asDriver(onErrorJustReturn: []))
    }
    
    private func fetchTrendingMedia() {
        Task {
            do {
                let media = try await networkManager.fetchTrending(mediaType: .movie)
                let items = media.results.map { MediaItem(title: $0.title ?? $0.name ?? "", imageUrl: $0.posterPath, id: $0.id) }
                dump(items)
                DispatchQueue.main.async { [weak self] in
                    self?.trendingMedia.accept(items)
                }
            } catch {
                print("trending 통신 에러 \(error)")
            }
        }
    }
    
    private func searchMedia(query: String) -> Observable<[MediaItem]> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            Task {
                do {
                    let media = try await self.networkManager.fetchSearch(mediaType: .movie, query: query)
                    let items = media.results.map { MediaItem(title: $0.title ?? $0.name ?? "", imageUrl: $0.posterPath, id: $0.id) }
                    dump(items)
                    observer.onNext(items)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func selectedMedia(_ item: MediaItem) {
        goToDetail.onNext(item.id)
        print(item.id)
    }
}

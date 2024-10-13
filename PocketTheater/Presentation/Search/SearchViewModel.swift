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
    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true
    private var currentQuery = ""
    struct Input {
        let searchText: ControlProperty<String>
        let itemSelected: ControlEvent<IndexPath>
        let prefetchItems: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let mediaResults: Driver<[MediaSection]>
        let gotoDetail: PublishSubject<Int>
        let isSearching: Driver<Bool>
        let hasNoResults: Driver<Bool>
    }
    
    init() {
        fetchTrendingMedia()
    }
    
    func transform(input: Input) -> Output {
        let isSearching = input.searchText.map { !$0.isEmpty }
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
            .do(onNext: { [weak self] _ in
                self?.currentPage = 1  // 새 검색어 입력 시 페이지 초기화
                self?.hasMorePages = true  // 더 가져올 페이지가 있는지 여부도 초기화
                self?.isFetching = false   // 새로운 검색 시작 시, 상태 초기화
            })
            .bind(to: self.searchMedia)
            .disposed(by: disposeBag)
       
        let noResult = Observable.combineLatest(isSearching, searchMedia) { isSearching, search in
            isSearching && search.isEmpty
        }.asDriver(onErrorJustReturn: false)
        
        let mediaResults = Observable.combineLatest(trendingMedia, searchMedia, isSearching) { trending, search, isSearching in
            if !isSearching {
                return [MediaSection(model: "추천 시리즈 & 영화", items: trending)]
            } else if search.isEmpty {
                return []
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
        
        input.prefetchItems
            .map { $0.map { $0.item } }
            .debug("adasdasdas")// IndexPath를 Int로 변환
            .subscribe(onNext: { [weak self] indexes in
                self?.prefetchIfNeeded(indexes: indexes)
            })
            .disposed(by: disposeBag)
        
        return Output(
            mediaResults: mediaResults.asDriver(onErrorJustReturn: []),
            gotoDetail: goToDetail,
            isSearching: isSearching.asDriver(onErrorJustReturn: false),
            hasNoResults: noResult
        )
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
                    let media = try await self.networkManager.searchMedia(mediaType: .movie, query: query,page: self.currentPage)
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
    
    private func prefetchIfNeeded(indexes: [Int]) {
        guard let maxIndex = indexes.max() else { return }
        
        let totalItemCount = searchMedia.value.count
        let thresholdIndex = max(0, totalItemCount - 5)  // 마지막 5개 항목에 가까워질 때 추가 페이지 요청
        
        print("Prefetch triggered - Max Index: \(maxIndex), Threshold: \(thresholdIndex), Total Items: \(totalItemCount)")
        print("Current conditions - isFetching: \(isFetching), hasMorePages: \(hasMorePages)")
        
        if maxIndex >= thresholdIndex && !isFetching && hasMorePages {
            print("Conditions met, calling fetchNextPage()")
            fetchNextPage()
        } else {
            print("Conditions not met, skipping fetchNextPage()")
        }
    }
    
    private func fetchNextPage() {
        print("fetchNextPage called - Current Page: \(currentPage)")
        guard !isFetching && hasMorePages else {
            print("Fetch skipped - isFetching: \(isFetching), hasMorePages: \(hasMorePages)")
            return
        }
        
        isFetching = true
        print("Fetching page \(currentPage + 1)")
        
        Task {
            do {
                let media = try await networkManager.searchMedia(mediaType: .movie, query: currentQuery, page: currentPage + 1)
                let newItems = media.results.map { MediaItem(title: $0.title ?? $0.name ?? "", imageUrl: $0.posterPath, id: $0.id) }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    var currentItems = self.searchMedia.value
                    currentItems.append(contentsOf: newItems)
                    self.searchMedia.accept(currentItems)
                    
                    self.hasMorePages = media.page < media.totalPages
                    self.currentPage += 1
                    self.isFetching = false
                }
            } catch {
                print("Error fetching next page: \(error)")
                self.isFetching = false
            }
        }
    }
}

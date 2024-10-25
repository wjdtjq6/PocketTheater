//
//  SearchViewModel.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager.shared
    private let trendingMedia = BehaviorRelay<[Result]>(value: [])
    private let searchMedia = BehaviorRelay<[Result]>(value: [])
    private let goToDetail = PublishSubject<Result>()
    private var currentPage = 1
    private var isFetching = false
    private var hasMorePages = true
    private var currentQuery = ""

    struct Input {
        let searchText: ControlProperty<String>
        let itemSelected: ControlEvent<IndexPath>
        let prefatchTrigger: Observable<Void>
    }
    
    struct Output {
        let mediaResults: Driver<[MediaSection]>
        let gotoDetail: PublishSubject<Result>
        let isSearching: Driver<Bool>
        let hasNoResults: Driver<Bool>
        let isLoading: Driver<Bool>
    }
    
    init() {
        fetchTrendingMedia()
    }
    
    func transform(input: Input) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isSearching = input.searchText.map { !$0.isEmpty }
        
        let searchResults = input.searchText
                   .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                   .distinctUntilChanged()
                   .do(onNext: { [weak self] query in
                       self?.currentQuery = query
                       self?.currentPage = 1
                       self?.hasMorePages = true
                       self?.isFetching = false
                   })
                   .flatMapLatest { [weak self] query -> Observable<[Result]> in
                       guard let self = self, !query.isEmpty else {
                           return .just([])
                       }
                       return self.searchMedia(query: query)
                   }
                   .share()

               searchResults
                   .bind(to: searchMedia)
                   .disposed(by: disposeBag)

        let prefetchResults = input.prefatchTrigger
            .filter { [weak self] in
                guard let self = self else { return false }
                return !self.isFetching && self.hasMorePages && !self.currentQuery.isEmpty
            }
            .flatMapLatest { [weak self] _ -> Observable<[Result]> in
                guard let self = self else { return .empty() }
                self.isFetching = true
                isLoading.accept(true)
                return self.searchMedia(query: self.currentQuery)
                    .do(onNext: { _ in
                        self.isFetching = false
                        isLoading.accept(false)
                    })
            }
            .share()

        prefetchResults
            .withLatestFrom(searchMedia) { newResults, currentResults in
                return currentResults + newResults
            }
            .bind(to: searchMedia)
            .disposed(by: disposeBag)

        let noResult = Observable.combineLatest(isSearching, searchMedia) { isSearching, search in
            isSearching && search.isEmpty
        }

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
            .bind(to: goToDetail)
            .disposed(by: disposeBag)

        return Output(
            mediaResults: mediaResults.asDriver(onErrorJustReturn: []),
            gotoDetail: goToDetail,
            isSearching: isSearching.asDriver(onErrorJustReturn: false),
            hasNoResults: noResult.asDriver(onErrorJustReturn: false),
            isLoading: isLoading.asDriver()
        )
    }
    
    private func fetchTrendingMedia() {
        Task {
            do {
                let media = try await networkManager.fetchTrending(mediaType: .movie)
                let items = media.results
                DispatchQueue.main.async { [weak self] in
                    self?.trendingMedia.accept(items)
                }
            } catch {
                print("trending 통신 에러 \(error)")
            }
        }
    }
    
    private func searchMedia(query: String) -> Observable<[Result]> {
           return Observable.create { [weak self] observer in
               guard let self = self else {
                   observer.onCompleted()
                   return Disposables.create()
               }
               
               Task {
                   do {
                       let media = try await self.networkManager.searchMedia(mediaType: .movie, query: query, page: self.currentPage)
                       let items = media.results
                       print("Received items: \(items)") // 디버깅을 위한 로그
                       self.hasMorePages = media.page < media.totalPages
                       self.currentPage += 1
                       
                       DispatchQueue.main.async {
                           observer.onNext(items)
                           observer.onCompleted()
                       }
                   } catch {
                       print("Search error: \(error)") // 오류 로그
                       DispatchQueue.main.async {
                           observer.onError(error)
                       }
                   }
               }
               
               return Disposables.create()
           }
       }
}

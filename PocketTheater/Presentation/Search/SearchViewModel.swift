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
    private let networkMAnager = NetworkManager.shared
    
    struct Input {
        let searchText: ControlProperty<String>
        let itemSelected: ControlEvent<IndexPath>
//        let viewDidloadTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let searchResults: Driver<[MediaItem]>
    }
    
   
    func transform(input: Input) -> Output {
        let searchResults = input.searchText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] query -> Observable<[MediaItem]> in
                guard let self = self else { return .empty() }
                return self.searchMedia(query: query)
            }
            .asDriver(onErrorJustReturn: [])
        
        input.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectedMedia(at: indexPath)
            })
            .disposed(by: disposeBag)
        
//        input.viewDidloadTrigger
        
        return Output(searchResults: searchResults)
    }
    
    private func searchMedia(query: String) -> Observable<[MediaItem]> {
        return .just([
            MediaItem(title: "\(query) 결과 1", imageUrl: nil),
            MediaItem(title: "\(query) 결과 2", imageUrl: nil),
            MediaItem(title: "\(query) 결과 3", imageUrl: nil)
        ])
    }
    
    private func selectedMedia(at indexPath: IndexPath) {
        // 선택된 아이템 처리 로직
        print("선택된 아이템: \(indexPath)")
    }
}

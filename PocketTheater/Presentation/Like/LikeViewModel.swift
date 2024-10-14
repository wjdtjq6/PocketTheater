//
//  LikeViewModel.swift
//  PocketTheater
//
//  Created by junehee on 10/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator

struct LikeDataSection {
    var header: String
    var items: [Like]
}

extension LikeDataSection: SectionModelType {
    init(original: LikeDataSection, items: [Like]) {
        self = original
        self.items = items
    }
}

final class LikeViewModel: ViewModelType {
    
    private let repository = LikeRepository()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: PublishSubject<Void>
        let itemDeleted: Observable<Like>
    }
    
    struct Output {
        let likeList: PublishSubject<[LikeDataSection]>
    }
    
    func transform(input: Input) -> Output {
        let likeList = PublishSubject<[LikeDataSection]>()
        
        let initialLoad = input.viewDidLoadTrigger
            .flatMap { [weak self] _ -> Observable<[LikeDataSection]> in
                guard let self = self else { return Observable.just([]) }
                return self.getLikeSections()
            }
        
        let deletions = input.itemDeleted
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] like in
                self?.repository.deleteLikeMedia(media: like)
            })
            .flatMap { [weak self] _ -> Observable<[LikeDataSection]> in
                guard let self = self else { return Observable.just([]) }
                return self.getLikeSections()
            }
        
        Observable.merge(initialLoad, deletions)
            .bind(to: likeList)
            .disposed(by: disposeBag)
        
        return Output(likeList: likeList)
    }
    
    private func getLikeSections() -> Observable<[LikeDataSection]> {
        return repository.getAllLikeMediaObservable()
            .map { likes in
                [LikeDataSection(header: "영화 시리즈", items: likes)]
            }
    }
}

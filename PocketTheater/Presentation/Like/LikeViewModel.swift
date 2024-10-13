//
//  LikeViewModel.swift
//  PocketTheater
//
//  Created by junehee on 10/12/24.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit // 임시

final class LikeViewModel: ViewModelType {
    
    private let repository = LikeRepository()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: PublishSubject<Void>
        let itemDeleted: ControlEvent<TestData>
    }
    
    struct Output {
        let likeList: PublishSubject<[LikeDataSection]>
    }
    
    func transform(input: Input) -> Output {
        let likeList = PublishSubject<[LikeDataSection]>()
        
        // 내가 찜한 리스트 데이터 바인딩
        input.viewDidLoadTrigger
            .map { _ in
                print("안녕")
                return [LikeDataSection(header: "영화 시리즈", items: [
                   TestData(title: "1번", image: UIImage()),
                   TestData(title: "2번", image: UIImage()),
                   TestData(title: "3번", image: UIImage()),
                   TestData(title: "4번", image: UIImage()),
               ])]
            }
            .bind { data in
                likeList.onNext(data)
            }
            .disposed(by: disposeBag)
        
        // 내가 찜한 리스트 밀어서 삭제
        input.itemDeleted
            .observe(on: MainScheduler.asyncInstance)
            .withUnretained(self)
            .bind { model, indexPath in
                // Realm 삭제 후 likeList 새로운 데이터 바인딩
                print("삭제 >>>", model, indexPath)
            }
            .disposed(by: disposeBag)
        
        
        return Output(likeList: likeList)
    }
    
}

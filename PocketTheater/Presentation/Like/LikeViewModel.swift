//
//  LikeViewModel.swift
//  PocketTheater
//
//  Created by junehee on 10/12/24.
//

import Foundation
import RxCocoa
import RxSwift

final class LikeViewModel: ViewModelType {
    
    private let repository = LikeRepository()
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
}

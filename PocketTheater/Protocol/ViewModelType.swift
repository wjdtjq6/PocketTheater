//
//  ViewModelType.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

//
//  NSObjectProtocol+Extension.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import Foundation

extension NSObjectProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

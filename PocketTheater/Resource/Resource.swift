//
//  Resource.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

enum Resource {
    
    enum Font {
        static let bold23 = UIFont.boldSystemFont(ofSize: 23)
        static let bold22 = UIFont.boldSystemFont(ofSize: 22)
        static let bold21 = UIFont.boldSystemFont(ofSize: 21)
        static let bold20 = UIFont.boldSystemFont(ofSize: 20)
        static let bold19 = UIFont.boldSystemFont(ofSize: 19)
        static let bold18 = UIFont.boldSystemFont(ofSize: 18)
        static let bold17 = UIFont.boldSystemFont(ofSize: 17)
        static let bold16 = UIFont.boldSystemFont(ofSize: 16)
        static let bold15 = UIFont.boldSystemFont(ofSize: 15)
        static let bold14 = UIFont.boldSystemFont(ofSize: 14)
        static let bold13 = UIFont.boldSystemFont(ofSize: 13)
        static let bold12 = UIFont.boldSystemFont(ofSize: 12)
        
        static let regular20 = UIFont.systemFont(ofSize: 20)
        static let regular19 = UIFont.systemFont(ofSize: 19)
        static let regular18 = UIFont.systemFont(ofSize: 18)
        static let regular17 = UIFont.systemFont(ofSize: 17)
        static let regular16 = UIFont.systemFont(ofSize: 16)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular13 = UIFont.systemFont(ofSize: 13)
        static let regular12 = UIFont.systemFont(ofSize: 12)
    }

    enum Image {
        static let play = UIImage(systemName:  "play.fill")
        static let search = UIImage(systemName:  "magnifyingglass")
        static let tv = UIImage(systemName:  "sparkles.tv")
        static let house = UIImage(systemName:  "house.fill")
        static let playCircle = UIImage(systemName:  "play.circle")
        static let download = UIImage(systemName:  "square.and.arrow.down")
        static let smileFace = UIImage(systemName:  "face.smiling")
        static let plus = UIImage(systemName:  "plus")
    }

    enum Color {
        static let white = UIColor(hex: "FFFFFF") // 흰색
        static let black = UIColor(hex: "000000") // 검은색
        static let eerieBlack = UIColor(hex: "1B1B1E") // 이리 블랙
        static let darkGray = UIColor(hex: "373737") // 다크 그레이
        static let lightGray = UIColor(hex: "FC2125") // 레드
    }

}

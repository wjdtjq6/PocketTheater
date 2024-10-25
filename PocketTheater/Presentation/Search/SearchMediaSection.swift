//
//  SearchMediaSection.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/12/24.
//

import RxDataSources

struct MediaSection {
    var model: String
    var items: [Result]
}

extension MediaSection: SectionModelType {
    init(original: MediaSection, items: [Result]) {
        self = original
        self.items = items
    }
}

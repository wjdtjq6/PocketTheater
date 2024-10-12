//
//  SearchView.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import SnapKit
import Then

class SearchView: BaseView {
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "게임, 시리즈, 영화를 검색하세요."
        $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        $0.barStyle = .black
        $0.searchBarStyle = .minimal
    }
    
    let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Resource.CollectionViewLayout.createMediaPlayCellLayout()).then {
        $0.register(MediaPlayCollectionViewCell.self, forCellWithReuseIdentifier: MediaPlayCollectionViewCell.identifier)
        $0.backgroundColor = Resource.Color.black
    }
    override func setHierarchy() {
        addSubview(searchBar)
        addSubview(searchCollectionView)
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
   
    
    
}

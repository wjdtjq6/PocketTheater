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
        $0.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        $0.register(NoResultsCell.self, forCellWithReuseIdentifier: NoResultsCell.identifier)
        $0.register(MediaSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MediaSectionHeaderView.identifier)
        $0.backgroundColor = Resource.Color.black
    }
    
    let noResultsLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isHidden = true
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .white
        $0.hidesWhenStopped = true
    }
    
    override func setHierarchy() {
        addSubview(searchBar)
        addSubview(searchCollectionView)
        addSubview(noResultsLabel)
        addSubview(activityIndicator)
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        noResultsLabel.snp.makeConstraints { make in
            make.center.equalTo(searchCollectionView)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(searchCollectionView)
        }
    }
}

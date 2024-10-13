//
//  MediaCollectionViewCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class MediaCollectionViewCell: BaseCollectionViewCell {

    let disposeBag = DisposeBag()
    let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    override func setHierarchy() {
        addSubview(mediaImageView)
    }
    
    override func setLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func updateCell(_ data: Result) async throws {
        guard let path = data.backdropPath else { return }
        let image = try await NetworkManager.shared.fetchImage(imagePath: path)
        if Task.isCancelled { return }
        mediaImageView.image = UIImage(data: image)
    }

    /// `추후 네트워크 연결 후 삭제할 메서드 입니다.`
    func updateCellTest(_ data: UIImage) async throws {
        mediaImageView.image = data
    }
    
}

<<<<<<< HEAD
extension MediaCollectionViewCell {
    func configure(with item: Result) {
        if let imageUrlString = item.posterPath,
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)") {
            DispatchQueue.main.async {
                self.mediaImageView.kf.setImage(with: imageUrl)
            }
        } else {
            mediaImageView.image = UIImage(named: "placeholder")
        }
    }
}
=======
>>>>>>> de9f5b6 (Fix: navigationbar & tabbar 스크롤 시 색상 변경 문제 해결)

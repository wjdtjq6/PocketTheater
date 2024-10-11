//
//  DetailView.swift
//  PocketTheater
//
//  Created by junehee on 10/10/24.
//

import UIKit
import SnapKit
import Then

class DetailView: BaseView {
    
    // 상단 대표 이미지
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        // 임시 이미지 영역 확인용
        $0.backgroundColor = .red
    }
    
    // 스크롤뷰
    private lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.addSubview(container)
    }
    
    // 스크롤뷰 안에 넣을 컨테이너
    private lazy var container = UIView().then {
        $0.addSubview(titleLabel)
        $0.addSubview(voteAverageLabel)
        $0.addSubview(playButton)
        $0.addSubview(saveButton)
        $0.addSubview(overviewLabel)
        $0.addSubview(castLabel)
        $0.addSubview(creatorLabel)
        $0.addSubview(similarContentLabel)
        $0.addSubview(searchCollectionView)
    }
    
    // 미디어 제목
    private let titleLabel = UILabel().then {
        $0.font = Resource.Font.bold17
        $0.textColor = Resource.Color.white
        // 임시 텍스트 확인용
        $0.text = "인사이드 아웃 2"
        
    }
    
    // 미디어 평점
    private let voteAverageLabel = UILabel().then {
        $0.font = Resource.Font.bold13
        $0.textColor = Resource.Color.white
        // 임시 텍스트 확인용
        $0.text = "7.6"
    }
    
    // 재생 버튼 (폰트 사이즈 수정하기)
    private let playButton = ActionButton(mode: .play, fontSize: 13)
    
    // 저장 버튼 (폰트 사이즈 수정하기)
    private let saveButton = ActionButton(mode: .save, fontSize: 13)
    
    // 미디어 설명
    let overviewLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = Resource.Font.regular14
        $0.textColor = Resource.Color.white
        $0.isUserInteractionEnabled = true
        // 임시 텍스트 확인용
        $0.text = "13살이 된 라일리의 행복을 위해 매일 바쁘게 머릿속 감정 컨트롤 본부를 운영하는 ‘기쁨’, ‘슬픔’, ‘버럭’, ‘까칠’, ‘소심’. 그러던 어느 날, 낯선 감정인 ‘불안’, ‘당황’, ‘따분’, ‘부럽’이가 본부에 등장하고, 언제나 최악의 상황을 대비하며 제멋대로인 ‘불안’이와 기존 감정들은 계속 충돌한다. 결국 새로운 감정들에 의해 본부에서 쫓겨나게 된 기존 감정들은 다시 본부로 돌아가기 위해 위험천만한 모험을 시작하는데…"
    }
    
    // 출연진
    private let castLabel = UILabel().then {
        $0.font = Resource.Font.regular12
        $0.textColor = Resource.Color.white
        // 임시 텍스트 확인용
        $0.text = "출연: 에이미 플러미야, 호크 켕신턴 돌먼"
    }
    
    // 제작진
    private let creatorLabel = UILabel().then {
        $0.font = Resource.Font.regular12
        $0.textColor = Resource.Color.white
        // 임시 텍스트 확인용
        $0.text = "출연: 켈시 맨, 피트 닥터"
    }
    
    // 비슷한 콘텐츠
    private let similarContentLabel = UILabel().then {
        $0.font = Resource.Font.bold15
        $0.textColor = Resource.Color.white
        $0.text = "비슷한 콘텐츠"
    }
    
    // 비슷한 콘텐츠 컬렉션뷰
    private lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Resource.CollectionViewLayout.MediaLayout()).then {
        $0.backgroundColor = Resource.Color.black
        $0.isScrollEnabled = false
        $0.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        $0.dataSource = self
    }
    
    override func setHierarchy() {
        self.addSubview(imageView)
        self.addSubview(scrollView)
    }
    
    override func setLayout() {
        let safeArea = self.safeAreaLayoutGuide
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(200)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(searchCollectionView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top).offset(16)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(20)
        }
        
        voteAverageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(20)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(voteAverageLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(30)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(container).inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(16)
        }
        
        creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(16)
        }
        
        similarContentLabel.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(container).inset(16)
            make.height.equalTo(20)
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarContentLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(container)
            make.height.equalTo(600) /// 임의 높이 설정 -> `기기별 대응 필요`
        }
    }
    
}

extension DetailView: UICollectionViewDataSource {

    // 비슷한 콘텐츠 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
            return MediaCollectionViewCell()
        }
        
        return cell
    }
    
}

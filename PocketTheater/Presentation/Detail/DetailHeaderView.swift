//
//  DetailHeaderView.swift
//  PocketTheater
//
//  Created by junehee on 10/11/24.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

/**
 
 */
final class DetailHeaderView: UICollectionReusableView {
    static let elementKind = UICollectionView.elementKindSectionHeader
    
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
    let playButton = ActionButton(mode: .play, fontSize: 13)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setHierarchy() {
        [titleLabel, voteAverageLabel, playButton, saveButton, overviewLabel, castLabel, creatorLabel, similarContentLabel].forEach { self.addSubview($0) }
    }
    
    private func setLayout() {
        let safeArea = self.safeAreaLayoutGuide
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(20)
        }
        
        voteAverageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(20)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(voteAverageLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(playButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(30)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeArea).inset(16)
        }
        
        castLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(16)
        }
        
        creatorLabel.snp.makeConstraints { make in
            make.top.equalTo(castLabel.snp.bottom)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(16)
        }
        
        similarContentLabel.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeArea).inset(16)
            make.height.equalTo(20)
        }
    }
    
    
    func updateHeaderView(_ data: Result) {
        // 헤더의 UI 요소를 Result 데이터로 업데이트
        titleLabel.text = data.title  // Result의 title을 UILabel에 할당
        voteAverageLabel.text = "\(data.voteAverage)"  // Result의 평점을 UILabel에 할당
        overviewLabel.text = data.overview  // Result의 설명을 UILabel에 할당
    }
}

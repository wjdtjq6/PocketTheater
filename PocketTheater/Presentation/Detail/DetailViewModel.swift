//
//  DetailViewModel.swift
//  PocketTheater
//
//  Created by junehee on 10/10/24.
//

import Foundation
import RxCocoa
import RxSwift

class DetailViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let mediaSubject: PublishSubject<Result>
    }
    
    struct Output {
        let dataSource: PublishSubject<[DetailSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let dataSource = PublishSubject<[DetailSectionModel]>()
        
        let detailInfo = PublishSubject<Result>()
        
        typealias CastCrew = ([String], [String])
        
        let castInfo = PublishSubject<[String]>()
        let crewInfo = PublishSubject<[String]>()
        let similarList = PublishSubject<[Result]>()
        
        // cast & crew
        input.mediaSubject
            .bind { media in
                // print("💕", media)
                Task {
                    let (cast, crew) = await self.getCast(media)
                    castInfo.onNext(cast)
                    crewInfo.onNext(crew)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        // similar items
        input.mediaSubject
            .bind { media in
                // print("🍀", media)
                Task {
                    let data = await self.getSimilarMedia(media)
                    // print("🐦‍🔥", data)
                    similarList.onNext(data)
                }
            }
            .disposed(by: disposeBag)
     
        let dataSourceObservable = Observable
            .combineLatest(input.mediaSubject, castInfo, crewInfo, similarList)
            .map { (media, cast, crew, similar) in
                let detail = MediaDetail(movie: media, cast: cast, crew: crew, similar: similar)
                        
                // items 배열 생성
                let items: [DetailItem] = [
                    .header(detail), // MediaDetail을 포함하는 header 아이템
                    .media(similar) // Result 배열을 포함하는 media 아이템
                ]
                
                return [DetailSectionModel(header: "", items: items)]
            }
            
    
        dataSourceObservable
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        
        return Output(dataSource: dataSource)
    }
    
    // 캐스팅 가져오기
    private func getCast(_ media: Result) async -> ([String], [String]) {
        guard let type = MediaType(rawValue: media.mediaType) else { return ([], []) }
        do {
            let data = try await NetworkManager.shared.fetchCast(mediaType: type, id: media.id)
            let cast = data.cast.map { $0.name }
            let crew = data.crew.map { $0.name }
            return (cast, crew)
        } catch {
            print("Cast 통신 에러 \(error)")
            return ([], [])
        }
    }

    // 비슷한 콘텐츠 가져오기
    private func getSimilarMedia(_ media: Result) async -> [Result] {
        guard let type = MediaType(rawValue: media.mediaType) else { return [] }
        do {
            let media = try await NetworkManager.shared.fetchSimilar(mediaType: type, id: media.id)
            let items = media.results.map { $0 }
            dump(items)
            return items
        } catch {
            print("Similar 통신 에러 \(error)")
            return []
        }
    }
    
}

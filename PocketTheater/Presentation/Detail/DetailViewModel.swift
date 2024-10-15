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
        
        input.mediaSubject
                .flatMap { media -> Observable<MediaDetail> in
                    Observable.zip(
                        self.getCast(media),
                        self.getSimilarMedia(media)
                    ).map { (castCrew, similar) in
                        let (cast, crew) = castCrew
                        return MediaDetail(movie: media, cast: cast, crew: crew, similar: similar)
                    }
                }
                .map { detail in
                    [
                        DetailSectionModel(header: "", items: [.header(detail)]),
                        DetailSectionModel(header: "비슷한 콘텐츠", items: detail.similar.map { .media($0) })
                    ]
                }
                .bind(to: dataSource)
                .disposed(by: disposeBag)
        
        // cast & crew
            input.mediaSubject
                .flatMap { media -> Observable<([String], [String])> in
                    return self.getCast(media)
                }
                .bind { cast, crew in
                    castInfo.onNext(cast)
                    crewInfo.onNext(crew)
                }
                .disposed(by: disposeBag)
        
        
        
        // similar items
            input.mediaSubject
                .flatMap { media -> Observable<[Result]> in
                    return self.getSimilarMedia(media)
                }
                .bind { data in
                    similarList.onNext(data)
                }
                .disposed(by: disposeBag)
     
        let dataSourceObservable = Observable
            .combineLatest(
                input.mediaSubject.asObservable(),
                castInfo.asObservable(),
                crewInfo.asObservable(),
                similarList.asObservable()
            )
            .map { (media, cast, crew, similar) in
                let detail = MediaDetail(movie: media, cast: cast, crew: crew, similar: similar)
                        
                let items: [DetailItem] = [
                    .header(detail),  // MediaDetail을 포함하는 header 아이템
                ] + similar.map { .media($0) }  // 각 Result 항목을 개별 아이템으로 변환

                
                return [DetailSectionModel(header: "", items: items)]
            }
            
    
        dataSourceObservable
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        
        return Output(dataSource: dataSource)
    }
    
    // 캐스팅 가져오기
    private func getCast(_ media: Result) -> Observable<([String], [String])> {
        return Observable.create { observer in
            Task {
                let type = MediaType(rawValue: media.mediaType ?? "") ?? .unknown
                do {
                    let data = try await NetworkManager.shared.fetchCast(mediaType: type, id: media.id)
                    let cast = data.cast.map { $0.name }
                    let crew = data.crew.map { $0.name }
                    observer.onNext((cast, crew))
                    observer.onCompleted()
                } catch {
                    print("Cast 통신 에러 \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }


    // 비슷한 콘텐츠 가져오기
    private func getSimilarMedia(_ media: Result) -> Observable<[Result]> {
        return Observable.create { observer in
            Task {
                let type = MediaType(rawValue: media.mediaType ?? "") ?? .unknown
                do {
                    let media = try await NetworkManager.shared.fetchSimilar(mediaType: type, id: media.id)
                    let items = media.results
                    observer.onNext(items)
                    observer.onCompleted()
                } catch {
                    print("Similar 통신 에러 \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}

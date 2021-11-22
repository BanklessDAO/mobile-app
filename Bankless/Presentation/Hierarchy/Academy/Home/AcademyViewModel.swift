//
//  Created with ♥ by BanklessDAO contributors on 2021-11-18.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Foundation
import RxSwift
import RxCocoa

class AcademyViewModel: BaseViewModel, AcademyServiceDependency {
    // MARK: - Input/Output -
    
    struct Input {
        let refresh: Driver<Void>
        let selection: Driver<ViewModelFoundation>
    }
    
    struct Output {
        let title: Driver<String>
        let academyCourseViewModels: Driver<[AcademyCourseViewModel]>
    }
    
    // MARK: - Events -
    
    struct Events {
        let academyCourseTransitionRequest = PublishRelay<AcademyCourse>()
    }
    
    let events = Events()
    
    // MARK: - Constants -
    
    private static let title = NSLocalizedString(
        "academy.list.title", value: "Academy", comment: ""
    )
    
    // MARK: - Properties -
    
    private var autoRefresh = PublishRelay<Void>()
    
    // MARK: - Components -
    
    var academyService: AcademyService!
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        bindSelection(input: input.selection)
        
        let academyCourseViewModels = courses(
            refreshInput: Driver.merge(
                [input.refresh, autoRefresh.asDriver(onErrorDriveWith: .empty())]
            )
        )
            .map({ $0.map(AcademyCourseViewModel.init) })
        
        return Output(
            title: .just(AcademyViewModel.title),
            academyCourseViewModels: academyCourseViewModels.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    // MARK: - List -
    
    private func courses(
        refreshInput: Driver<Void>
    ) -> Observable<[AcademyCourse]> {
        return refreshInput
            .asObservable()
            .flatMapLatest({ [weak self] _ -> Observable<[AcademyCourse]> in
                guard let self = self else { return .empty() }
                
                return self.academyService.listCourses()
                    .map({ $0.courses })
            })
    }
    
    // MARK: - Selection -
    
    private func bindSelection(
        input: Driver<ViewModelFoundation>
    ) {
        input.asObservable()
            .subscribe(onNext: { [weak self] viewModel in
                switch viewModel {
                    
                case let academyCourseViewModel as AcademyCourseViewModel:
                    self?.events.academyCourseTransitionRequest
                        .accept(academyCourseViewModel.academyCourse)
                default:
                    break
                }
            })
            .disposed(by: disposer)
    }
}

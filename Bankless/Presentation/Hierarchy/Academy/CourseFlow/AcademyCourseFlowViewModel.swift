//
//  Created with ♥ by BanklessDAO contributors on 2021-11-22.
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

final class AcademyCourseFlowViewModel: BaseViewModel,
                                        AcademyServiceDependency,
                                        UserSettingsServiceDependency
{
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let title: Driver<String>
        let currentSectionViewModel: Driver<AcademyCourseSectionViewModel>
        let sectionNavViewModel: Driver<SectionNavigationViewModel>
    }
    
    // MARK: - Constants -
    
    private static func navTitleForSection(current: Int, total: Int) -> String {
        return String.localizedStringWithFormat(
            NSLocalizedString(
                "academy.course.flow.navigation.control.title.format",
                value: "Section %d of %d",
                comment: ""
            ),
            current,
            total
        )
    }
    
    // MARK: - Properties -
    
    private let currentSectionIndex = BehaviorRelay<Int>(value: 0)
    
    // MARK: - Data -
    
    private let academyCourse: AcademyCourse
    
    // MARK: - Components -
    
    var academyService: AcademyService!
    var userSettingsService: UserSettingsService!
    
    // MARK: - Events -
    
    struct Events {
        let academyCourseCompletionRequest = PublishRelay<Void>()
    }
    
    let events = Events()
    
    // MARK: - Initializers -
    
    init(academyCourse: AcademyCourse, container: DependencyContainer? = nil) {
        self.academyCourse = academyCourse
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let currentSectionVM = self.sectionViewModel().replayAll()
        let sectionNavVM = self.sectionNavViewModel(currentSectionVM: currentSectionVM)
        
        currentSectionVM.connect().disposed(by: disposer)
        
        return Output(
            title: .just(academyCourse.name),
            currentSectionViewModel: currentSectionVM.asDriver(onErrorDriveWith: .empty()),
            sectionNavViewModel: sectionNavVM.asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func sectionNavViewModel(
        currentSectionVM: Observable<AcademyCourseSectionViewModel>
    ) -> Observable<SectionNavigationViewModel> {
        Observable
            .combineLatest(
                currentSectionIndex.asObservable(),
                currentSectionVM.flatMap({ $0.isLocking.asObservable() })
            )
            .map({ (index: $0.0, isLocking: $0.1) })
            .map({ [weak self] currentSection in
                guard let self = self else {
                    return .init(source: .init(title: "", navigationOptions: [], progress: 0))
                }
                
                let navTitle = AcademyCourseFlowViewModel.navTitleForSection(
                    current: currentSection.index + 1,
                    total: self.academyCourse.sections.count
                )
                
                let isBackNavEnabled = currentSection.index > 0
                let isForwardNavEnabled =
                currentSection.index < self.academyCourse.sections.count - 1
                && !currentSection.isLocking
                
                let sectionNavVM = SectionNavigationViewModel(
                    source: .init(
                        title: navTitle.uppercased(),
                        navigationOptions: (isBackNavEnabled ? [.back] : [])
                        + (isForwardNavEnabled ? [.forward] : []),
                        progress: Float((currentSection.index + 1))
                            / Float(self.academyCourse.sections.count)
                    )
                )
                
                sectionNavVM.navigationRequest.asObservable()
                    .map({ navRequest in
                        switch navRequest {
                            
                        case .back:
                            return self.currentSectionIndex.value - 1
                        case .forward:
                            return self.currentSectionIndex.value + 1
                        }
                    })
                    .bind(to: self.currentSectionIndex)
                    .disposed(by: sectionNavVM.disposer)
                
                return sectionNavVM
            })
    }
    
    private func sectionViewModel() -> Observable<AcademyCourseSectionViewModel> {
        currentSectionIndex.asObservable()
            .map({ [weak self] sectionIndex in
                guard let self = self else { fatalError("unexpected navigation request") }
                
                let viewModel = AcademyCourseSectionFactory
                    .createSectionViewModel(for: self.academyCourse.sections[sectionIndex])
                
                switch viewModel {
                    
                case let poapSectionViewModel as AcademyCoursePoapSectionViewModel:
                    self.bindClaim(
                        request: poapSectionViewModel.claimPoapRequest.asObservable(),
                        onCompleted: { [weak self] in
                            self?.events.academyCourseCompletionRequest.accept(())
                        }
                    )
                        .subscribe()
                        .disposed(by: poapSectionViewModel.disposer)
                default:
                    break
                }
                
                return viewModel
            })
    }
    
    // MARK: - Actions -
    
    private func bindClaim(
        request: Observable<Void>,
        onCompleted: @escaping () -> Void
    ) -> Completable {
        fatalError("not implemented")
    }
}

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

final class AcademyCourseDetailsViewModel: BaseViewModel, AcademyServiceDependency {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let difficulty: Driver<String>
        let duration: Driver<String>
        let title: Driver<String>
        let description: Driver<String>
        let detailViewModels: Driver<[AcademyCourseDetailViewModel]>
        let collectibleImageURL: Driver<URL?>
        let sectionNavViewModel: Driver<SectionNavigationViewModel>
    }
    
    // MARK: - Constants -
    
    private static let durationEmoji = "🕓"
    private static let durationUnitTitle = NSLocalizedString(
        "academy.course.duration.unit.title",
        value: "min",
        comment: ""
    )
    private static let detailTitles = (
        knowledgeRequirements: NSLocalizedString(
            "academy_course.details.knowledge_requirements.title",
            value: "Knowledge requirements?",
            comment: ""
        ),
        takeaways: NSLocalizedString(
            "academy_course.details.takeaways.title",
            value: "What will you learn from this?",
            comment: ""
        ),
        powerUps: NSLocalizedString(
            "academy_course.details.powerUps.title",
            value: "What will you be able to do by the end of this course?",
            comment: ""
        )
    )
    private static let actionButtonTitle = NSLocalizedString(
        "academy.course.details.action.start.title",
        value: "Start Now",
        comment: ""
    )
    
    // MARK: - Data -
    
    private let academyCourse: AcademyCourse
    
    // MARK: - Components -
    
    var academyService: AcademyService!
    
    // MARK: - Events -
    
    struct Events {
        let academyCourseStartFlowRequest = PublishRelay<AcademyCourse>()
    }
    
    let events = Events()
    
    // MARK: - Initializers -
    
    init(academyCourse: AcademyCourse, container: DependencyContainer? = nil) {
        self.academyCourse = academyCourse
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let detailViewModels = [
            Detail(
                title: AcademyCourseDetailsViewModel.detailTitles.knowledgeRequirements,
                body: academyCourse.knowledgeRequirements
            ),
            Detail(
                title: AcademyCourseDetailsViewModel.detailTitles.takeaways,
                body: academyCourse.learnings
            ),
            Detail(
                title: AcademyCourseDetailsViewModel.detailTitles.powerUps,
                body: academyCourse.learningActions
            )
        ]
            .map(AcademyCourseDetailViewModel.init)
        
        let sectionNavVM = SectionNavigationViewModel(
            source: .init(
                title: AcademyCourseDetailsViewModel.actionButtonTitle.uppercased(),
                progress: 0.0
            )
        )
        bindAction(
            input: sectionNavVM.navigationRequest
                .asDriver(onErrorDriveWith: .empty())
                .map({ _ in () })
        )
        
        return Output(
            difficulty: .just(academyCourse.difficulty.title),
            duration: self.durationString().asDriver(onErrorDriveWith: .empty()),
            title: .just(academyCourse.name),
            description: .just(academyCourse.description),
            detailViewModels: .just(detailViewModels),
            collectibleImageURL: .just(academyCourse.poapImageLink),
            sectionNavViewModel: .just(sectionNavVM)
        )
    }
    
    private func durationString() -> Observable<String> {
        // Assuming the duration is stored in seconds
        let minutes = academyCourse.duration % 60
        
        return .just(
            AcademyCourseDetailsViewModel.durationEmoji
            + " " + String(minutes)
            + " " + AcademyCourseDetailsViewModel.durationUnitTitle
        )
    }
    
    // MARK: - Actions -
    
    private func bindAction(input: Driver<Void>) {
        input.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.events.academyCourseStartFlowRequest.accept(self.academyCourse)
            })
            .disposed(by: disposer)
    }
}

extension AcademyCourseDetailsViewModel {
    struct Detail: AcademyCourseDetail {
        let title: String
        let body: String
    }
}

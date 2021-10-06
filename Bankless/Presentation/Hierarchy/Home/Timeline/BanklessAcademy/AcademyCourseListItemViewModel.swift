//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

class AcademyCourseListItemViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let backgroundImageURL: Driver<URL>
        let title: Driver<String>
        let description: Driver<String>
        let difficulty: Driver<String>
        let duration: Driver<String>
    }
    
    // MARK: - Constants -
    
    private static let durationEmoji = "🕓"
    private static let durationUnitTitle = NSLocalizedString(
        "academy.course.duration.unit.title",
        value: "min",
        comment: ""
    )
    
    // MARK: - Data -
    
    private let academyCourse: AcademyCourse
    
    // MARK: - Initializers -
    
    init(academyCourse: AcademyCourse) {
        self.academyCourse = academyCourse
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        return Output(
            backgroundImageURL: .just(academyCourse.backgroundImageURL),
            title: .just(academyCourse.name),
            description: .just(academyCourse.description),
            difficulty: .just(academyCourse.difficulty.title),
            duration: self.durationString().asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func durationString() -> Observable<String> {
        // Assuming the duration is stores in seconds
        let minutes = academyCourse.duration % 60
        
        return .just(
                AcademyCourseListItemViewModel.durationEmoji
                    + " " + String(minutes)
                    + " " + AcademyCourseListItemViewModel.durationUnitTitle
            )
    }
}

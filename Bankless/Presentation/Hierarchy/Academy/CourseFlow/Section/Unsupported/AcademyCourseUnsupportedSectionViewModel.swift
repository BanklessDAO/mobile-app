//
//  Created with ♥ by BanklessDAO contributors on 2021-12-01.
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

final class AcademyCourseUnsupportedSectionViewModel: BaseViewModel, AcademyCourseSectionViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output { }
    
    // MARK: - Data -
    
    let section: AcademyCourse.Section
    let isLocking: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Initializers -
    
    init(section: AcademyCourse.Section, container: DependencyContainer? = nil) {
        self.section = section
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        return Output()
    }
}

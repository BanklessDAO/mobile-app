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

final class AcademyCoursePoapSectionViewModel: BaseViewModel, AcademyCourseSectionViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let claim: Driver<Void>
    }
    
    struct Output {
        let poapImageURL: Driver<URL>
    }
    
    // MARK: - Data -
    
    let section: AcademyCourse.Section
    let isLocking: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Events -
    
    let claimPoapRequest = PublishRelay<Void>()
    
    // MARK: - Initializers -
    
    init(section: AcademyCourse.Section, container: DependencyContainer? = nil) {
        self.section = section
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        input.claim.asObservable().bind(to: claimPoapRequest).disposed(by: disposer)
        
        return Output(
            poapImageURL: .just(section.poapImageLink!)
        )
    }
}

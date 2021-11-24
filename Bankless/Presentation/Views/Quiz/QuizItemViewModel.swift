//
//  Created with ♥ by BanklessDAO contributors on 2021-11-23.
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

final class QuizItemViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let tapOption: Driver<Int>
    }
    
    struct Output {
        let options: Driver<[String]>
        let validOptionIndex: Driver<Int>
        let isPassed: Driver<Bool>
    }
    
    // MARK: - Properties -
    
    let validationRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Data -
    
    let quizItem: QuizItem
    
    // MARK: - Initializers -
    
    init(quizItem: QuizItem, container: DependencyContainer? = nil) {
        self.quizItem = quizItem
        super.init(container: container)
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        let isPassed = input.tapOption
            .map({ [weak self] in $0 == self?.quizItem.validOptionIndex ?? -1 })
            .do(onNext: { [weak self] in self?.validationRelay.accept($0) })
        
        return Output(
            options: .just(quizItem.options),
            validOptionIndex: .just(quizItem.validOptionIndex),
            isPassed: isPassed.asDriver(onErrorDriveWith: .empty())
        )
    }
}

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

final class SectionNavigationViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let tapNavigationOption: Driver<NavigationOption>
    }
    
    struct Output {
        let title: Driver<String>
        let progress: Driver<Float>
        let navigationOptions: Driver<[NavigationOption]>
    }
    
    // MARK: - Data -
    
    private let source: Source
    
    // MARK: - Events -
    
    let navigationRequest = PublishRelay<NavigationOption>()
    
    // MARK: - Initializers -
    
    init(source: Source) {
        self.source = source
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        input.tapNavigationOption
            .drive(onNext: { [weak self] in self?.navigationRequest.accept($0) })
            .disposed(by: disposer)
        
        let navOptions: [NavigationOption] = [
            source.progress > 0.0 ? .back : nil,
            source.progress < 0.0 ? .forward : nil
        ].compactMap({ $0 })
        
        return Output(
            title: .just(source.title),
            progress: .just(source.progress),
            navigationOptions: .just(navOptions)
        )
    }
}

extension SectionNavigationViewModel {
    struct Source {
        let title: String
        let progress: Float
    }
    
    enum NavigationOption {
        case back
        case forward
    }
}

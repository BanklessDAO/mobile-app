//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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

final class BountyViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let title: Driver<String>
        let reward: Driver<String>
        let status: Driver<(title: String, color: UIColor)>
    }
    
    // MARK: - Data -
    
    let bounty: Bounty
    
    // MARK: - Initializers -
    
    init(bounty: Bounty) {
        self.bounty = bounty
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        return Output(
            title: .just(bounty.title),
            reward: self.rewardString().asDriver(onErrorDriveWith: .empty()),
            status: .just((title: bounty.status.title, color: bounty.status.colorCode))
        )
    }
    
    private func rewardString() -> Observable<String> {
        return .just(
            String(Int(bounty.reward.amount))
            + " " + bounty.reward.currency
        )
    }
}

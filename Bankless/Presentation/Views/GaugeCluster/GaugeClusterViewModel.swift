//
//  Created with ♥ by BanklessDAO contributors on 2021-10-14.
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
import DateToolsSwift

final class GaugeClusterViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input {
        let tapAchievements: Driver<Void>
    }
    
    struct Output {
        let isAnonymous: Driver<Bool>
        let balance: Driver<String>
        let lastTransaction: Driver<String>
        let achievementImageURLs: Driver<[URL]?>
        let lastAchievementMessage: Driver<String>
    }
    
    // MARK: - Constants -
    
    private static let defaultBalanceCurrency = "BANK"
    private static let placeholderStrings = (
        lastTransaction: NSLocalizedString(
            "bankless.token.transaction.placeholder.message",
            value: "No transactions on the record",
            comment: ""
        ),
        achievements: NSLocalizedString(
            "achievements.event.placeholder.message",
            value: "Your achievements will live here!",
            comment: ""
        )
    )
    private static let transactionStringFormats = (
        generic: NSLocalizedString(
            "bankless.token.transaction.sent.message",
            value: "Last transaction: %@",
            comment: ""
        ),
        received: NSLocalizedString(
            "bankless.token.transaction.received.message",
            value: "Received %@ %@",
            comment: ""
        ),
        sent: NSLocalizedString(
            "bankless.token.transaction.sent.message",
            value: "Sent %@ %@",
            comment: ""
        )
    )
    private static let achievementMessageStringFormats = (
        poap: NSLocalizedString(
            "achievements.event.poap.message",
            value: "Received a POAP %@",
            comment: ""
        ),
        dummy: ""
    )
    
    // MARK: - Data -
    
    private let bankAccount: BANKAccount?
    private let attendanceTokens: [AttendanceToken]?
    
    // MARK: - Initializers -
    
    init(
        bankAccount: BANKAccount?,
        attendanceTokens: [AttendanceToken]?
    ) {
        self.bankAccount = bankAccount
        self.attendanceTokens = attendanceTokens
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        bind(tapAchievements: input.tapAchievements)
        
        let attendanceTokenImages = attendanceTokens?
            .map({ $0.imageUrl })
            ?? []
        
        return Output(
            isAnonymous: .just(bankAccount == nil),
            balance: balanceString().asDriver(onErrorDriveWith: .empty()),
            lastTransaction: lastTransactionString().asDriver(onErrorDriveWith: .empty()),
            achievementImageURLs: .just(attendanceTokenImages),
            lastAchievementMessage: lastAchievementMessage().asDriver(onErrorDriveWith: .empty())
        )
    }
    
    private func balanceString() -> Observable<String> {
        return .just(
            (bankAccount?.amountString() ?? "0")
            + " " + GaugeClusterViewModel.defaultBalanceCurrency
        )
    }
    
    private func lastTransactionString() -> Observable<String> {
        guard let lastTransactionTimestamp = bankAccount?.lastTransactionTimestamp
        else {
            return .just(GaugeClusterViewModel.placeholderStrings.lastTransaction)
        }
        
        let timeString = lastTransactionTimestamp.timeAgoSinceNow.lowercased()
        
        return .just(
            String.localizedStringWithFormat(
                GaugeClusterViewModel.transactionStringFormats.generic,
                timeString
            )
        )
    }
    
    private func lastAchievementMessage() -> Observable<String> {
        guard let lastAttendanceToken = attendanceTokens?
                .sorted(by: { $0.mintedAt > $1.mintedAt })
                .first
        else {
            return .just(GaugeClusterViewModel.placeholderStrings.achievements)
        }
        
        let eventStringFormat = GaugeClusterViewModel.achievementMessageStringFormats.poap
        
        let timeString = lastAttendanceToken.mintedAt.timeAgoSinceNow.lowercased()
        
        return .just(
            String.localizedStringWithFormat(eventStringFormat, timeString)
        )
    }
    
    // MARK: - Events -
    
    private func bind(tapAchievements: Driver<Void>) {
        tapAchievements
            .drive(onNext: {
                NotificationCenter.default
                    .post(
                        name: NotificationEvent.achievementsPreviewTapped.notificationName,
                        object: nil
                    )
            })
            .disposed(by: disposer)
    }
}

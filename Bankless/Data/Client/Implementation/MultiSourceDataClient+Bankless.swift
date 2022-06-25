//
//  Created with ♥ by BanklessDAO contributors on 2022-06-24.
//  Copyright (C) 2022 BanklessDAO.

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
import BigInt

extension MultiSourceDataClient: BanklessClient {
    // MARK: - Constants -
    
    private static let bankTokenDecimalPlaces = 0
    
    // MARK: - Methods -
    
    func getUserBANKAccount(request: BANKAccountRequest) -> Observable<BANKAccount> {
        return apolloRequest(
            apolloClient: bankTokenGraphQLClient,
            apolloQuery: BankAccountQuery(ethAddress: request.ethAddress.lowercased()),
            responseType: BANKAccount.self
        ) { graphQLResult in
            if let responseData = graphQLResult.data {
                let accountInfo = responseData.account
                
                let balanceIntString = accountInfo != nil
                ? String(accountInfo!.erc20balances.first!.value.split(separator: ".").first!)
                : nil
                
                let fromTXs = [BANKAccount.Transaction]()
                let toTXs = [BANKAccount.Transaction]()
                
                let lastTransactionTimestamp = accountInfo?.lastTransactionTimestamp != nil
                ? Date(
                    timeIntervalSince1970: TimeInterval(accountInfo!.lastTransactionTimestamp)!
                )
                : nil
                
                let bankAccount = BANKAccount(
                    address: request.ethAddress,
                    balance: (
                        balanceIntString != nil
                        ? BigInt(stringLiteral: balanceIntString!)
                        : BigInt(0)
                    ) * BigInt(10).power(MultiSourceDataClient.bankTokenDecimalPlaces),
                    transactions: fromTXs + toTXs,
                    lastTransactionTimestamp: lastTransactionTimestamp
                )
                
                return .success(bankAccount)
            } else if let errors = graphQLResult.errors {
                return .failure(DataError.rawCollection(errors))
            } else {
                fatalError("not supported")
            }
        }
    }
}

//
//  Created with ♥ by BanklessDAO contributors on 2021-11-17.
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

final class MarkupViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let rawMarkup: Driver<String>
        let renderedContent: Driver<NSAttributedString>
    }
    
    // MARK: - Data -
    
    let rawMarkup: String
    
    // MARK: - Initializers -
    
    init(rawMarkup: String) {
        self.rawMarkup = rawMarkup
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
        guard let renderedContent = rawMarkup.convertToAttributedFromHTML() else {
            fatalError("Markup rendering failed")
        }
        
        let html = """
        <html>
            <head>
                <style>
                    body {
                        font-family: -apple-system, Helvetica;
                        sans-serif;
                        color: white;
                    }
                    img {
                        width: 100%;
                        height: auto;
                    }
                    a {
                        color: #BF3531;
                    }
                </style>
                <meta
                    name="viewport"
                    content="
                        width=device-width, initial-scale=1,
                        maximum-scale=1.0, minimum-scale=1.0 user-scalable=no
                    "
                >
            </head>
            <body>
                \(rawMarkup)
            </body>
        </html>
        """
        
        return Output(
            rawMarkup: .just(html),
            renderedContent: .just(renderedContent)
        )
    }
}

extension String {
    func convertToAttributedFromHTML() -> NSAttributedString? {
        return nil
    }
}

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

final class AcademyCourseDetailViewModel: BaseViewModel {
    // MARK: - Input/Output -
    
    struct Input { }
    
    struct Output {
        let title: Driver<String>
        let body: Driver<NSAttributedString>
    }
    
    // MARK: - Data -
    
    let academyCourseDetail: AcademyCourseDetail
    
    // MARK: - Initializers -
    
    init(academyCourseDetail: AcademyCourseDetail) {
        self.academyCourseDetail = academyCourseDetail
    }
    
    // MARK: - Transformer -
    
    func transform(input: Input) -> Output {
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
                \(academyCourseDetail.body)
            </body>
        </html>
        """
        
        return Output(
            title: .just(academyCourseDetail.title),
            body: .just(html.renderedString ?? .init())
        )
    }
}

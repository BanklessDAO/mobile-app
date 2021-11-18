//
//  Created with ♥ by BanklessDAO contributors on 2021-11-16.
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

struct ShowMorePlaceholderItem: NewsItemPreviewBehaviour {
    var previewImageURL: URL {
        fatalError("not implemented")
    }
    
    var categoryTitle: String {
        fatalError("not implemented")
    }
    
    var title: String {
        return NSLocalizedString(
            "home.timeline.news.navigation.show_more.title",
            value: "Show More",
            comment: ""
        )
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    init() { }
}

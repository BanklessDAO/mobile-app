//
//  Created with ♥ by BanklessDAO contributors on 2021-11-10.
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

struct DiscordUser: Codable {
    let id: String
    let handle: String
    
    init(
        id: String,
        handle: String
    ) {
        self.id = id
        self.handle = handle
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: DiscordUser.CodingKey.self)
        
        self.id = try! container.decode(String.self, forKey: .id)
        self.handle = try! container.decode(String.self, forKey: .username)
            + "#" + (try! container.decode(String.self, forKey: .discriminator))
    }
}

extension DiscordUser {
    enum CodingKey: String, Swift.CodingKey {
        case id
        case username
        case discriminator
    }
}

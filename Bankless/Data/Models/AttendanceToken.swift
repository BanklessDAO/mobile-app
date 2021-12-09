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

struct AttendanceToken: Codable {
    let id: String
    let ownerAddress: String
    let mintedAt: Date
    let imageUrl: URL
    
    init(id: String, ownerAddress: String, mintedAt: Date, imageUrl: URL) {
        self.id = id
        self.ownerAddress = ownerAddress
        self.mintedAt = mintedAt
        self.imageUrl = imageUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: AttendanceToken.CodingKey.self)
        
        self.id = try! container.decode(String.self, forKey: .tokenId)
        self.ownerAddress = try! container.decode(String.self, forKey: .owner)
        
        if let dateString = try? container.decode(String.self, forKey: .created) {
            self.mintedAt = Date(
                dateString: dateString,
                format: "yyyy-MM-dd HH:mm:ss"
            )
        } else {
            self.mintedAt = Date()
        }
        
        let eventContainer = try! container
            .nestedContainer(keyedBy: CodingKey.Event.self, forKey: .event)
        
        self.imageUrl = URL(string: try! eventContainer.decode(String.self, forKey: .image_url))!
    }
}

extension AttendanceToken {
    enum CodingKey: String, Swift.CodingKey {
        case tokenId
        case owner
        case created
        case event
    
        enum Event: String, Swift.CodingKey {
            case image_url
        }
    }
}

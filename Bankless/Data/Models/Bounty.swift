//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

struct Bounty: Codable {
    let id: String
    let season: String
    let title: String
    let descrtiption: String
    let criteria: String
    let reward: Reward
    let createdBy: DiscordUser
    let createdAt: Date?
    let dueAt: Date?
    let discordMessageId: String?
    let status: Status
    let statusHistory: [StatusEvent]
    let claimedBy: DiscordUser?
    let claimedAt: Date?
    let submissionNotes: String?
    let submissionUrl: URL?
    let submittedAt: Date?
    let submittedBy: DiscordUser?
    let reviewedAt: Date?
    let reviewedBy: DiscordUser?
}

extension Bounty {
    struct Reward: Codable {
        let currency: String
        let amount: Float
        let scale: Int
    }
    
    struct StatusEvent: Codable {
        let status: Status
        let setAt: Date
    }
    
    enum Status: String, Codable, CaseIterable {
        case draft
        case open
        case inProgress
        case inReview
        case completed
        case deleted
    }
}

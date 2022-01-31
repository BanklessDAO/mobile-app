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

struct AcademyCourse: Codable {
    let id: String
    let name: String
    let slug: String
    let backgroundImageURL: URL
    let notionId: String
    let poapEventId: Int
    let description: String
    let duration: Int
    let difficulty: Difficulty
    let poapImageLink: URL
    let learnings: String
    let learningActions: String
    let knowledgeRequirements: String
    let sections: [Section]
}

extension AcademyCourse {
    enum Difficulty: String, Codable, CaseIterable {
        case easy
        case medium
        case hard
    }
    
    struct Section: Codable {
        let id: String
        let type: `Type`
        let title: String
        let content: String?
        let quiz: Quiz?
        let component: String?
        let poapImageLink: URL?
    }
}

extension AcademyCourse.Section {
    enum `Type`: String, Codable, CaseIterable {
        case learn
        case quiz
        case quest
        case poap
    }
    
    struct Quiz: Codable {
        let id: String
        let question: String
        let answers: [String]?
        let rightAnswerNumber: Int
    }
}

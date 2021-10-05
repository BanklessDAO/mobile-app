//
//  Created with ♥ by BanklessDAO contributors on 2021-10-05.
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
import Fakery

private let faker = Faker(locale: "en-US")

// MARK: - Member -

extension Member: Mock {
    static func generateMock() -> Member {
        return .init(
            id: UUID().uuidString,
            discordHandle: faker.internet.username(separator: nil),
            discordId: String(Int.random(in: 1_000_000 ... 10_000_000))
        )
    }
}

// MARK: - Academy -

extension AcademyCourse: Mock {
    static func generateMock() -> AcademyCourse {
        return .init(
            id: UUID().uuidString,
            name: faker.lorem.sentence(wordsAmount: 3).capitalized,
            slug: faker.internet.username(separator: nil),
            backgroundImageURL: URL(string: faker.internet.image())!,
            notionId: UUID().uuidString,
            poapEventId: Int.random(in: 0 ... 1_000_000),
            description: faker.company.catchPhrase(),
            duration: Int.random(in: 5 ... 40),
            difficulty: .allCases.randomElement()!,
            poapImageLink: URL(string: faker.internet.image())!,
            learnings: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            learningActions: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            knowledgeRequirements: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            sections: AcademyCourse.Section.generateMocks(Int.random(in: 2 ... 8))
        )
    }
}

extension AcademyCourse.Section: Mock {
    static func generateMock() -> AcademyCourse.Section {
        return .init(
            id: UUID().uuidString,
            type: .allCases.randomElement()!,
            title: faker.lorem.sentence(wordsAmount: 3).capitalized,
            content: faker.lorem.paragraphs(amount: 3),
            quiz: .generateMock(),
            component: nil
        )
    }
}

extension AcademyCourse.Section.Quiz: Mock {
    static func generateMock() -> AcademyCourse.Section.Quiz {
        return .init(
            id: UUID().uuidString,
            answers: [
                faker.lorem.word(),
                faker.lorem.word(),
                faker.lorem.word(),
                faker.lorem.word()
            ],
            rightAnswerNumber: Int.random(in: 0 ... 4)
        )
    }
}

// MARK: - Bounties -

extension Bounty: Mock {
    static func generateMock() -> Bounty {
        return .init(
            id: UUID().uuidString,
            season: String(Int.random(in: 1 ... 2)),
            title: faker.lorem.sentence(wordsAmount: 3).capitalized,
            descrtiption: faker.lorem.paragraphs(amount: 3),
            criteria: faker.lorem
                .sentence(wordsAmount: Int.random(in: 20 ... 40)).capitalized,
            reward: .generateMock(),
            createdBy: .generateMock(),
            createdAt: faker.date.backward(days: .random(in: 0 ... 1_000)),
            dueAt: faker.date.forward(.random(in: 2 ... 1_000)),
            discordMessageId: nil,
            status: .allCases.randomElement()!,
            statusHistory: [],
            claimedBy: .generateMock(),
            claimedAt: faker.date.backward(days: .random(in: 0 ... 1_000)),
            submissionNotes: faker.lorem
                .sentence(wordsAmount: Int.random(in: 20 ... 40)).capitalized,
            submissionUrl: nil,
            submittedAt: faker.date.backward(days: .random(in: 0 ... 1_000)),
            submittedBy: .generateMock(),
            reviewedAt: faker.date.backward(days: .random(in: 0 ... 1_000)),
            reviewedBy: .generateMock()
        )
    }
}

extension Bounty.Reward: Mock {
    static func generateMock() -> Bounty.Reward {
        return .init(
            currency: "BANK",
            amount: Float(Int.random(in: 1000 ... 10000)),
            scale: 1
        )
    }
}

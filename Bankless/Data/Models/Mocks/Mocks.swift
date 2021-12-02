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
import BigInt

private let faker = Faker(locale: "en-US")

// MARK: - Discord user -

extension DiscordUser: Mock {
    static func generateMock() -> DiscordUser {
        return .init(
            id: UUID().uuidString,
            handle: faker.internet.username()
        )
    }
}

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
            backgroundImageURL: URL(string: "https://ethereum.org/static/28214bb68eb5445dcb063a72535bc90c/96d01/hero.png")!,
            notionId: UUID().uuidString,
            poapEventId: Int.random(in: 0 ... 1_000_000),
            description: faker.company.catchPhrase(),
            duration: Int.random(in: 5 ... 40),
            difficulty: .allCases.randomElement()!,
            poapImageLink: URL(string: "https://storage.googleapis.com/poapmedia/bankless-academy-intro-to-defi-2021-logo-1630063060767.png")!,
            learnings: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            learningActions: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            knowledgeRequirements: faker.lorem.sentence(wordsAmount: Int.random(in: 5 ... 20)),
            sections: AcademyCourse.Section.generateMocks(Int.random(in: 10 ... 20))
        )
    }
}

extension AcademyCourse.Section: Mock {
    static func generateMock() -> AcademyCourse.Section {
        let type = `Type`.allCases.filter({ [.learn, .quiz].contains($0) }).randomElement()!
        
        return .init(
            id: UUID().uuidString,
            type: type,
            title: faker.lorem.sentence(wordsAmount: 3).capitalized,
            content: faker.lorem.paragraphs(amount: 3),
            quiz: .generateMock(),
            component: nil,
            poapImageLink: type == .poap ? URL(string: "https://storage.googleapis.com/poapmedia/bankless-academy-intro-to-defi-2021-logo-1630063060767.png")! : nil
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
            rightAnswerNumber: Int.random(in: 0 ..< 4)
        )
    }
}

// MARK: - Bounties -

extension Bounty: Mock {
    static func generateMock() -> Bounty {
        return .init(
            id: UUID().uuidString,
            season: String(Int.random(in: 1 ... 2)),
            title: faker.lorem.sentence(wordsAmount: 8).capitalized,
            descrtiption: faker.lorem
                .sentence(wordsAmount: Int.random(in: 60 ... 200)),
            criteria: faker.lorem
                .sentence(wordsAmount: Int.random(in: 20 ... 40)),
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

// MARK: - Attendance token -

extension AttendanceToken: Mock {
    static func generateMock() -> AttendanceToken {
        return .init(
            id: UUID().uuidString,
            ownerAddress: UUID().uuidString,
            mintedAt: faker.date.backward(days: .random(in: 0 ... 1_000)),
            imageUrl: URL(
                string: [
                    "https://storage.googleapis.com/poapmedia/banklessdao-dev-guild-weekly-sync-100421-2021-logo-1633379567327.png",
                    "https://storage.googleapis.com/poapmedia/banklessdao-dev-guild-weekly-sync-101121-2021-logo-1633899593231.png",
                    "https://storage.googleapis.com/poapmedia/joseph-turner-2021-logo-1634223520875.png",
                    "https://storage.googleapis.com/poapmedia/banklessdao-grants-committee-weekly-092821-2021-logo-1632861501883.png",
                ].randomElement()!
            )!
        )
    }
}

// MARK: - BANK Account -

extension BANKAccount: Mock {
    static func generateMock() -> BANKAccount {
        return .init(
            address: "0x" + faker.lorem.characters(amount: 40),
            balance: randomERC20Amount(),
            transactions: Transaction.generateMocks(.random(in: 10 ... 20)),
            lastTransactionTimestamp: faker.date.backward(days: .random(in: 1 ... 30))
        )
    }
}

extension BANKAccount.Transaction: Mock {
    static func generateMock() -> BANKAccount.Transaction {
        return .init(
            fromAddress: "0x" + faker.lorem.characters(amount: 40),
            toAddress: "0x" + faker.lorem.characters(amount: 40),
            amount: randomERC20Amount(10 ... 500)
        )
    }
}

// MARK: - Newsletter -

extension NewsletterItem: Mock {
    static func generateMock() -> NewsletterItem {
        return .init(
            id: UUID().uuidString,
            title: faker.lorem.sentence(wordsAmount: .random(in: 3 ... 40)),
            slug: faker.internet.username(),
            excerpt: faker.lorem.sentence(wordsAmount: .random(in: 20 ... 40)),
            createdAt: faker.date.backward(days: .random(in: 20 ... 365)),
            updatedAt: faker.date.backward(days: .random(in: 20 ... 365)),
            coverPictureURL: URL(string: "https://gobankless.ghost.io/content/images/2021/10/Decentralized-Arts--8-DaoPunk.png")!,
            url: URL(string: "https://gobankless.ghost.io/get-in-on-nfts-decentralized-arts-8/")!,
            htmlContent: newsletterHTMLContentSample,
            readingTimeInMinutes: .random(in: 5 ... 20),
            isFeatured: false
        )
    }
}

// MARK: - Podcast -

extension PodcastItem: Mock {
    static func generateMock() -> PodcastItem {
        return .init(
            id: UUID().uuidString,
            title: faker.lorem.sentence(wordsAmount: 3),
            description: faker.lorem.sentence(wordsAmount: .random(in: 60 ... 200)),
            publishedAt: faker.date.backward(days: .random(in: 20 ... 365)),
            thumbnailURL: URL(string: "https://i.ytimg.com/vi/NeQrSWa_qy8/sddefault.jpg")!,
            videoURL: URL(string: "https://www.youtube.com/watch?v=NeQrSWa_qy8")!
        )
    }
}

// MARK: - Utils -

private func randomERC20Amount(_ range: ClosedRange<Int> = 100 ... 2_000) -> BigInt {
    let amount = Int.random(in: range)
    return BigInt(stringLiteral: String(amount) + String.init(repeating: "0", count: 18))
}

// MARK: - Misc -

private let newsletterHTMLContentSample = "<h3 id=\"catch-up-with-what-happened-this-week-in-the-banklessdao\">Catch up with what happened this week in the BanklessDAO.</h3><p>Dear Bankless Nation,</p><p>Five months ago, Ryan and David lit a match and sparked a social movement. Today, we walk together on a journey of shared values and as a community driven to scale an impossible mission: to help onboard one billion people to the Bankless journey. We are the world's first media, education and culture DAO. We are settling, developing tools, and building a digital nation in the sky around a shared vision and goals. We have ambitious plans to grow, along with the economic resources to expand and make life inside the Bankless Nation better.</p><p>Today is the start of Season 2 and we are doubling down on building culture and lowering barriers to entry. The road ahead is long and there is a lot of work to be done, but we can be sure of one thing: BanklessDAO Builds!</p><p><strong>Authors</strong>: Bankless DAO Writers Guild (<a href=\"https://twitter.com/bcethhunter\" rel>BcEthHunter</a>, <a href=\"https://twitter.com/nonsensecodes\" rel>nonsensetwice</a>, <a href=\"https://twitter.com/0xSiddhearta\" rel>siddhearta</a>, <a href=\"https://twitter.com/jakeandstake\" rel>Jake and Stake</a>)</p><hr><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F12b9048a-e33a-455e-8cd8-9733e318c6b5_1280x456.png\" class=\"kg-image\" alt loading=\"lazy\"></figure><hr><p>This is the official newsletter of the <a href=\"https://www.bankless.community/\" rel>Bankless DAO</a>. </p><hr><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2Fb4a4c3e6-e832-4092-955c-4fabee870ec2_652x285.png\" class=\"kg-image\" alt loading=\"lazy\"></figure><p><em>UMA helps DAOs diversify their treasury and build community</em></p><hr><h2 id=\"banklessdao-weekly-nft-showcase-%F0%9F%94%A5\"><strong>BanklessDAO Weekly NFT Showcase 🔥</strong></h2><p>🧑‍🎨 <strong>Artist:</strong> <a href=\"https://twitter.com/jonaskasperjens\" rel>Jonas Kasper Jensen</a></p><p>🏦 <strong>Auction Type:</strong> 1/1</p><p>💰 <strong>Price:</strong> 1 wETH</p><p><strong>Internal as rooted in change // For the love of DEX and DAO</strong></p><p>“Internal as rooted in change // For the love of DEX and DAO” is a sound-art video that consists of abstract shapes in motion and a drone-like sound. The shapes look like internal organs and are a visual depiction of the internal change that blockchain technology brings with it.</p><p>The disruptive nature of DEXs (decentralized exchanges) and DAOs (decentralized anonymous organizations) is reflected as the video and sound play, but the possibility of staying at the status quo is also reflected in the loopy nature of the piece.</p><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F26426d9b-2a38-4903-b577-292c0ab17031_600x338.gif\" class=\"kg-image\" alt loading=\"lazy\"></figure><h2 id=\"community-highlights\"><strong>Community Highlights</strong></h2><p>🍁 <strong>Season 2 is LIVE!!</strong> Today is the day! The season 2 launch party took place on Twitter Spaces on 10/8/21 at 11am EST with around 500 guests. So many cool things are coming down the pipeline for Season 2! Get ready, we are on a wild ride! Here is a look at what to expect for Season 2 as we continue to build:</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Announcing Season 2 🏴<br> <br>Here&#39;s what to expect<br> <br>🧵<a href=\"https://t.co/nkEpJE5o0M\">https://t.co/nkEpJE5o0M</a></p>&mdash; Bankless DAO 🏴 (@banklessDAO) <a href=\"https://twitter.com/banklessDAO/status/1446157745816674322?ref_src=twsrc%5Etfw\">October 7, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p><strong><strong>Announcing Season 2: Settling New Territory — Mirror</strong>Bankless DAO has become the home for over 1,500 members on the bankless journey. We’re on a mission to help the world go Bankless by creating user-friendly onramps for people to discover decentralized technologies through education, media, and culture.banklessdao.mirror.xyz</strong></p><p>October 7th 2021<strong>74</strong> Retweets<strong>164</strong> Likes</p><p>☯️ <strong>State of the DAOs #0 Launches:</strong> Get the TL;DR on the DAO ecosystem. This bi-weekly newsletter is an easy-to-digest deep-dive into all things DAO. What are DAOs? How do they operate? What makes them different from regular incorporated organizations? How can you work for a DAO? Check out the Beginner Friendly Events Calendar at the bottom for event highlights, jobs, and where you need to be! This is a massive source of Alpha! Big thanks to scottyk and the team for <em>tons</em> of work!</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Bankless DAO just launched its first State of the DAOs newsletter, the high-signal low-noise newsletter for understanding DAOs.<br><br>Read the TL;DR below 👇<a href=\"https://t.co/HFPIaQ6YZW\">https://t.co/HFPIaQ6YZW</a><br><br>Thanks to <a href=\"https://twitter.com/scottykETH?ref_src=twsrc%5Etfw\">@scottykETH</a>, <a href=\"https://twitter.com/frogmonkee?ref_src=twsrc%5Etfw\">@frogmonkee</a>, <a href=\"https://twitter.com/0xSiddhearta?ref_src=twsrc%5Etfw\">@0xSiddhearta</a>, and <a href=\"https://twitter.com/WPeaster?ref_src=twsrc%5Etfw\">@WPeaster</a> for their efforts</p>&mdash; Bankless DAO 🏴 (@banklessDAO) <a href=\"https://twitter.com/banklessDAO/status/1445891474177069058?ref_src=twsrc%5Etfw\">October 6, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p>🐸 <strong>Be Collectively Intelligent!</strong> This is a great conversation with our very own frogmonkee and the host @joincolony. The discussion covered Season 1 at the BanklessDAO, decentralization vs. centralization and forms of governance. Listen, like and retweet to increase our collective intelligence.</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">🎙 New Collectively Intelligent podcast from <a href=\"https://twitter.com/joincolony?ref_src=twsrc%5Etfw\">@joincolony</a>!<br><br>Insights from <a href=\"https://twitter.com/banklessDAO?ref_src=twsrc%5Etfw\">@banklessDAO</a> Season 1 w/ <a href=\"https://twitter.com/frogmonkee?ref_src=twsrc%5Etfw\">@frogmonkee</a> <br><br>We had a great conversation around governance &amp; insights from within Bankless DAO. Enjoy!<a href=\"https://t.co/ekkpXtlq8V\">https://t.co/ekkpXtlq8V</a></p>&mdash; COMMODORΞ 🚢 (@thycommodore) <a href=\"https://twitter.com/thycommodore/status/1445742981227573258?ref_src=twsrc%5Etfw\">October 6, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p>🧠 <strong><a href=\"https://open.spotify.com/episode/22iOBmGobqRJEhBhtTC3Ye?si=GFFlaC_vSZaJNgvQlHjMIw&amp;utm_source=copy-link&amp;dl_branch=1&amp;nd=1\" rel>CryptoSapiens Podcast: Exploring the DAO ecosystem at MCON 2021</a></strong></p><p>This episode was recorded live at MCON in Denver, Colorado between September 15th and 17th. The recording comprises a series of vignettes with builders in attendance to learn a bit about them, their projects, and their experiences at the conference. The discussions were edited for clarity and brevity. Guests include <a href=\"https://twitter.com/AragonProject\" rel>@AragonProject</a>, <a href=\"https://twitter.com/harmonyprotocol\" rel>@harmonyprotocol</a>, <a href=\"https://twitter.com/nowdaoit\" rel>@nowdaoit</a>, <a href=\"https://twitter.com/Collab_Land_\" rel>@Collab_Land_</a>, and <a href=\"https://twitter.com/TheMetaFactory\" rel>@TheMetaFactory</a>.</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">The <a href=\"https://twitter.com/hashtag/MCON2021?src=hash&amp;ref_src=twsrc%5Etfw\">#MCON2021</a> mashup episode is out! We hope you enjoy the interviews with <a href=\"https://twitter.com/AragonProject?ref_src=twsrc%5Etfw\">@AragonProject</a> <a href=\"https://twitter.com/harmonyprotocol?ref_src=twsrc%5Etfw\">@harmonyprotocol</a> <a href=\"https://twitter.com/nowdaoit?ref_src=twsrc%5Etfw\">@nowdaoit</a> <a href=\"https://twitter.com/Collab_Land_?ref_src=twsrc%5Etfw\">@Collab_Land_</a> <a href=\"https://twitter.com/TheMetaFactory?ref_src=twsrc%5Etfw\">@TheMetaFactory</a>.<br><br>Thanks to <a href=\"https://twitter.com/Meta_Cartel?ref_src=twsrc%5Etfw\">@Meta_Cartel</a> for inviting us to participate in the event.<a href=\"https://t.co/T660spBOIs\">https://t.co/T660spBOIs</a></p>&mdash; Crypto Sapiens 🧠 (@CryptoSapiens_) <a href=\"https://twitter.com/CryptoSapiens_/status/1446299857405153282?ref_src=twsrc%5Etfw\">October 8, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p><strong>👨‍🎤 <a href=\"http://discord.gg/t9YfHJWAP9\" rel>DAOpunks Meme Contest</a>:</strong> Make a viral meme that plays off the theme \"Corporate Punk to DAOpunk\". Post your meme on your Twitter account and tag <a href=\"https://twitter.com/DAOpunksNFT\" rel>@DAOpunksNFT</a> to enter. The winner will be chosen on Friday, October 15 and will receive a free DAOpunk and the vanity role of @Meme Lord on the DAOpunks Discord server.</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Want to win a free DAOpunk and title of ultimate Meme Lord? Enter our meme contest! Check our discord for more details. Link in bio. 🏴🖤</p>&mdash; DAOpunks (@DAOpunksNFT) <a href=\"https://twitter.com/DAOpunksNFT/status/1446546732918222848?ref_src=twsrc%5Etfw\">October 8, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p>📊 <strong><a href=\"https://docs.google.com/presentation/d/18DGuSTsLgU2C2iNNcvoo2-27uL2Tcb1jfMaMGa9Zeyc/edit#slide=id.gf1c26dd130_1_0\" rel>Season 1 Growth and Engagement</a>:</strong> The Analytics Guild put together a great slide deck for community growth and engagement for Season 1. Membership has spiked in September, with total membership rising from 5000 in June to over 9000 by the end of September. The DAO continues to work on methods to activate and retain new members, transitioning people from silent visitors to active contributors. Engaged members who become active contributors soon realize that the opportunities to earn BANK are plentiful! Check out the <a href=\"https://docs.google.com/presentation/d/18DGuSTsLgU2C2iNNcvoo2-27uL2Tcb1jfMaMGa9Zeyc/edit#slide=id.gf1c26dd130_1_0\" rel>full presentation</a> with data on rewards, governance participation, and our mission to be the most data-driven DAO around!</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Our total discord membership is doing a the hockey stick🏒, <br><br>5K in June ➡️ &gt;9K in September <a href=\"https://t.co/Xkg0JGOJaW\">pic.twitter.com/Xkg0JGOJaW</a></p>&mdash; paulapivat.🔥Ξth 🏴 (@paulapivat) <a href=\"https://twitter.com/paulapivat/status/1446484378670882820?ref_src=twsrc%5Etfw\">October 8, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Across our 4 informal membership segments, we’ve seen massive growth:<br><br>• 1 – 10K   ↗️ 42% increase<br>• 10 – 35K ↗️ 81% increase<br>• 35 – 150K flat<br>• 150K &amp; beyond ↗️ 96% increase <a href=\"https://t.co/cqUym5ODzX\">pic.twitter.com/cqUym5ODzX</a></p>&mdash; paulapivat.🔥Ξth 🏴 (@paulapivat) <a href=\"https://twitter.com/paulapivat/status/1446484412971978755?ref_src=twsrc%5Etfw\">October 8, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><h2 id=\"get-involved\">Get Involved</h2><p>👋 <strong>New Members Welcome!</strong> If you are new to the DAO, welcome! This is the start of the journey of a lifetime and we look forward to working alongside you. We have ambitious growth plans, but we also have a lot of fun. Take some time to find your niche based on your skills and interests. Start small, join a meeting, and raise your hand for a project. Over time, you can collect bounties and earn your way towards membership. The only barrier to entry is your time and your willingness to contribute. Along the way, you can enjoy some of these excellent member benefits:</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Member Perks 😍<br> <br>🫂 Access to the Bankless DAO Community Hub<br>🍿 Front row to <a href=\"https://twitter.com/CryptoSapiens_?ref_src=twsrc%5Etfw\">@CryptoSapiens_</a> podcasts<br>🖼️ NFT Club <br>🎭 Top Signal Audience Participation<br>🧠 Mental Health Support<br>🪂 Giveaways and Airdrops<br>🧑‍🌾 Exclusive Yield Opportunities<br> <br>More perks to come in S3</p>&mdash; Bankless DAO 🏴 (@banklessDAO) <a href=\"https://twitter.com/banklessDAO/status/1446157774694412289?ref_src=twsrc%5Etfw\">October 7, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p>🏫 <strong>Bankless Academy is in Beta:</strong> Learn the easiest way to get into crypto with the Bankless Academy! Our Educational platform for all things in crypto and DeFi! The Bankless Academy has easy to digest content on the most important topics affecting you and your daily, crypto-verse life. Get early beta access by signing up for the email list in the link.</p><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Bankless Academy 🤓<br> <br>The best way for newcomers to onboard to crypto &amp; become a Bankless Jedi<br> <br>✅ Full squad assembled and working towards MVP<br>💰 Received $10,000 grant from <a href=\"https://twitter.com/0xPolygon?ref_src=twsrc%5Etfw\">@0xPolygon</a><br>💸 $5,500 grant from <a href=\"https://twitter.com/gitcoin?ref_src=twsrc%5Etfw\">@gitcoin</a> Grants<br> <br>Teaser website here:<a href=\"https://t.co/tpwoK5s7hR\">https://t.co/tpwoK5s7hR</a></p>&mdash; Bankless DAO 🏴 (@banklessDAO) <a href=\"https://twitter.com/banklessDAO/status/1446157764238012416?ref_src=twsrc%5Etfw\">October 7, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure><p>✍️ <strong><a href=\"https://discordapp.com/channels/834499078434979890/851849225049735208/895319783774511154\" rel>Contribute to the Writers Guild</a>:</strong> If you are reading this newsletter and think that writing or editing content is a place you can contribute, head over to the #Writers-Start-Here channel in Discord! By interacting with the Emoji, you can join a team and will be notified for the activities of the Newsletter Team and/or EPA (Editor and Publishing Arm.) #WritersGuildwasFIRST!</p><p>🧘 <strong><a href=\"https://discordapp.com/channels/834499078434979890/844341131864047656/895362295327244328\" rel>Weekly Mental Health Support</a>:</strong> The DAO is a big and stressful place at times! IRL things can also have many moving parts that can be overwhelming. Even the pros need to make good choices about their mental health. Join us weekly, on Wednesdays at 9:30am PDT in the #members-forum voice chat for all things health related. Mental, physical, and spiritual.</p><p>🧐 <strong>Knowledge Sessions:</strong> Defi &amp; Tokemak on Tuesday, October 12 at 6pm EDT with IcedCool.</p><hr><p>🙏 <strong>Sponsor:</strong> <a href=\"https://bankless.cc/UMA\" rel>UMA</a> — Diversifying DAO Treasuries. <a href=\"https://bankless.cc/UMA\" rel>DAO Better</a>.</p><hr><h2 id=\"introducing-degen-the-robotic-powerhouse-to-power-up-daos\">Introducing DEGEN, the Robotic Powerhouse to Power Up DAOs</h2><p>Written by <a href=\"https://twitter.com/nonsensecodes\" rel>nonsensetwice</a></p><p>Popular parlance for getting work done is \"The best tool for a job is the one in hand.\" It’s a great phrase to help motivate work, but it doesn’t fit in all cases. As another phrase goes, \"If all you have is a hammer, everything looks like a nail.\"</p><p>You need the right tool for each job, and while DAOs have made use of a myriad of tools for their varied needs, few are made specifically for DAOs.</p><p>Enter the Swiss Army knife of DAO tooling: DEGEN.</p><p>DEGEN’s history is brief, but won’t be discussed here. <a href=\"https://banklessdao.mirror.xyz/dGMysin2Zff48DZj3bB8lX4GaZ97OxeoAPdC1_YkUt0\" rel>You can read about it on Mirror</a>. Rather, let’s dive right into what DEGEN has to offer. In its current inception, DEGEN has on hand a few, but rather powerful, tools.</p><h3 id=\"the-bounty-board\">The Bounty Board</h3><p>DEGEN serves as the Discord-native implementation of the <a href=\"https://banklessdao.mirror.xyz/sie3cTas4AaZ0xzRuAYIUvOyTBLqQ_ABOxVLJ_osJ2U\" rel>Bounty Board</a>, making it possible for members to create, claim, and submit bounties on command, directly within Discord. Often, projects require work that lies outside the scope of their enlisted personnel. Utilizing the Bounty Board, teams can crowdsource this extraneous work and continue building with little to no disruption.</p><p>Soon, a new feature will surface to provide members the ability to scope out a project and find others who share their vision. Coupled with the Bounty Board, this will be a powerful toolset to empower members to contribute in whatever way they choose: Bounty Board for the freelance-minded or Scope Squad for the project-minded.</p><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F9b33880d-10f9-4068-949a-77ff200f8795_1748x513.jpeg\" class=\"kg-image\" alt loading=\"lazy\"></figure><h3 id=\"poap-distribution\">POAP Distribution</h3><p>However, the POAP distribution feature is what draws most of the attention to DEGEN. This substantially simplifies the process of ensuring event attendees receive their POAPs in a timely manner. There is no need to setup events. There is no need to get creative in obfuscating the password so only attendees can claim POAPs. DEGEN will listen in on an event, whether it’s in a standard voice channel or on a stage, record the attendees, and upon ending the event, DEGEN will ask for the claim links and distribute them to all active attendees.</p><p>“I made a list. Give me your list and I’ll use both lists to send out the POAPs.”</p><p>Working in this manner, many pain points in POAP distribution are solved. No more password phishing in channels and no more stealing claim links from spreadsheets. It’s a simple implementation of a better system, enabling event organizers to feel more confident about distributing POAPs to legitimate attendees.</p><p>And we’re offering it to Discord communities in the Web3 space—DAOs, NFT communities, crypto protocols—for free. If you are interested in bringing DEGEN to your community, <a href=\"https://docs.google.com/forms/d/e/1FAIpQLScgy2XMXmyneNUsoJt_y3PW5sUutv3IcElMHzk-CCAmImiwQQ/viewform\" rel>please take a moment to fill out this form</a>.</p><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F88a0ddf0-0352-4f91-966e-b3ef3bb67083_1732x495.jpeg\" class=\"kg-image\" alt loading=\"lazy\"></figure><h3 id=\"in-development\">In Development</h3><p>The POAP distribution feature is pretty cool, but pales in comparison to what else is offered. As more communities pick up DEGEN for the POAP distribution feature, they’ll come to recognize the power and value of features like the Bounty Board and upcoming Scope Squad. Eventually, DEGEN will be seen as <em><strong>the</strong> <strong>de facto</strong></em> Discord DAO tool, by bringing Web3 functionality to Discord in a way that hasn’t been explored before. Gnosis implementation is coming to DEGEN soon. And with Gnosis, many other features will be possible. A tipping mechanism is in the works; blockchain-agnostic services are in the works. There is no ceiling for what DEGEN is capable of, and in turn, there is no ceiling for what every community in this space can create.</p><p>The BanklessDAO's mission is to onboard 1 billion people into crypto, and it is the DEGEN team's belief that the best way to align with this mission is to automate and simplify tedious, complex tasks and thus empower DAOs and protocols to do what they do best: build a better, more sustainable culture that will attract users to this space.</p><p>If you are interested in bringing DEGEN to your community or you are part of a community that you think will benefit from these features, <a href=\"https://docs.google.com/forms/d/e/1FAIpQLScgy2XMXmyneNUsoJt_y3PW5sUutv3IcElMHzk-CCAmImiwQQ/viewform\" rel>please take a moment to fill out this form</a>.</p><hr><h2 id=\"%F0%9F%9A%A8-live-proposals-%F0%9F%9A%A8\">🚨 Live Proposals 🚨</h2><p>⚔️ <strong><a href=\"https://snapshot.org/#/banklessvault.eth/proposal/QmeUcnL5FTpF2ah2CCph6DZGqJzG19coT9b3ECLAvBxPH2\" rel>Season 2 Project and Guild Funding</a>:</strong> Per the <a href=\"https://snapshot.org/#/banklessvault.eth/proposal/QmSTXHWP7bjaxT9aAuoFNkaCn5Ptx7GajEDDekoBccd5Uf\" rel>Season 2 specification</a>, Guild and Project were each approved for 5 Million BANK and the Grants Committee was allocated 10.5M BANK, with 3.5M set aside for contributor rewards. This proposal seeks to ratify <em>where</em> these budgeted allocations will go (between guilds and projects) and seeks approval for a modification of an interpretation of the Season 2 Spec.</p><p>🕺 <strong><a href=\"https://snapshot.org/#/banklessvault.eth/proposal/QmVm6jzr7yDRiBmmkvCQ1MFw4jTaiJcME6ZNBp4QuU1DHA\" rel>Retro Rectification Donations</a>:</strong> The proposal aims to distribute BANK tokens to those who contributed to Gitcoin, fulfilling the promise made in the early days of BanklessDAO.</p><h2 id=\"proposals-in-discussion\"><strong>Proposals in Discussion</strong></h2><p>🦋 <strong><a href=\"https://forum.bankless.community/t/migrate-local-geographies-to-telegram/1831\" rel>Migrate local chapters to their own Telegram channel</a>:</strong> Our Discord has a ton of channels. It’s becoming too cluttered to follow all the active development and we need to think of ways to minimize this. Moving chapters to their own Telegram makes communication easier and increases the surface area of the DAO. Read up on all the moving parts here.</p><p>💸 <strong><a href=\"https://forum.bankless.community/t/bankless-dao-profit-distribution/1816\" rel>BanklessDAO Profit Distribution</a>:</strong> This proposal is a poll to gather a general consensus and collect feedback on future profits generated by the DAO. Listed are 4 versions of profit sharing models to vote on, each with different strengths and weaknesses. What a great sign of things to come in the BanklessDAO!</p><h2 id=\"action-items\"><strong>Action Items</strong></h2><p>📱 <strong><a href=\"https://t.me/BanklessDAO\" rel>Join Telegram</a>:</strong> For BanklessDAO news, updates, and activities.</p><p>🚨 <strong><a href=\"https://snapshot.org/#/banklessvault.eth\" rel>VOTE</a>:</strong> Snapshot proposals are live for the Season 2 funding and Retro-Distribution.</p><p>🏃‍♀️ <strong>Catch up:</strong> Review this week's community call <a href=\"https://www.notion.so/Season-2-Launch-7d06aaf56df444d48cd0d551edadebdc\" rel>notes</a> or listen to the <a href=\"https://www.twitch.tv/banklessdao\" rel>recording</a>.</p><hr><h3 id=\"%F0%9F%99%8Fthanks-to-our-sponsor\"><strong>🙏Thanks to our sponsor</strong></h3><h1 id=\"uma\"><strong><a href=\"https://bankless.cc/UMA\" rel>UMA</a></strong></h1><p><a href=\"https://bankless.cc/UMA\" rel>UMA</a> helps DAOs build products to diversify their treasury. Most DAOs treasuries are imbalanced. By using UMA’s success tokens and KPI options, DAOs can prepare their treasury for any market and build loyalty.</p><figure class=\"kg-card kg-image-card\"><img src=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F2e482250-7636-48e6-ae7d-fb7ced686c86_1400x800.png\" class=\"kg-image\" alt=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F2e482250-7636-48e6-ae7d-fb7ced686c86_1400x800.png\" loading=\"lazy\" title=\"https://cdn.substack.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fbucketeer-e05bbc84-baa3-437e-9518-adb32be77984.s3.amazonaws.com%2Fpublic%2Fimages%2F2e482250-7636-48e6-ae7d-fb7ced686c86_1400x800.png\"></figure><p>👉 <a href=\"https://bankless.cc/UMA\" rel>Join the #bankless Channel in the UMA Discord.</a></p><p>👉 <a href=\"https://bankless.cc/UMA\" rel>Tell UMA What DAOs you belong to.</a></p><p>👉 <a href=\"https://bankless.cc/UMA\" rel>Verified Bankless DAO members carn KPI Options. Go to the Discord to learn more.</a></p><hr><h2 id=\"meme-of-the-week\">Meme of the Week</h2><figure class=\"kg-card kg-embed-card\"><blockquote class=\"twitter-tweet\"><p lang=\"en\" dir=\"ltr\">Banks on dates Vs. Bankless on dates: <a href=\"https://t.co/xuv9fldR44\">pic.twitter.com/xuv9fldR44</a></p>&mdash; aboveaveragejoe.eth⚑⟠=🦇🔊💰 (@Abv_Avg_Joe) <a href=\"https://twitter.com/Abv_Avg_Joe/status/1446507151468470280?ref_src=twsrc%5Etfw\">October 8, 2021</a></blockquote>\n<script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>\n</figure>"

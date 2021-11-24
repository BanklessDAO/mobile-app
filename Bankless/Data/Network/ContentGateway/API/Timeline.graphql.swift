// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class TimelineQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Timeline {
      BanklessTokens(
        where: {address_equals: "0xbbc3d8108069b10a5859a08f31d140b9f357f73f"}
      ) {
        __typename
        data {
          __typename
          address
          balance
          transactions {
            __typename
            amount
            toAddress
            fromAddress
          }
        }
      }
      POAPTokens(where: {owner_equals: "0xbbc3d8108069b10a5859a08f31d140b9f357f73f"}) {
        __typename
        data {
          __typename
          id
          owner
          mintedAt
        }
      }
      Bounties {
        __typename
        data {
          __typename
          id
          title
          season
          description
          rewardAmount
        }
      }
      Courses(first: 3) {
        __typename
        data {
          __typename
          slug
          name
          duration
          difficulty
          description
          knowledgeRequirements
          learnings
          learningActions
          poapEventId
          poapImageLink
          sections {
            __typename
            type
            title
            content
            quiz {
              __typename
              answers
              rightAnswerNumber
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Timeline"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("BanklessTokens", arguments: ["where": ["address_equals": "0xbbc3d8108069b10a5859a08f31d140b9f357f73f"]], type: .object(BanklessToken.selections)),
        GraphQLField("POAPTokens", arguments: ["where": ["owner_equals": "0xbbc3d8108069b10a5859a08f31d140b9f357f73f"]], type: .object(PoapToken.selections)),
        GraphQLField("Bounties", type: .object(Bounty.selections)),
        GraphQLField("Courses", arguments: ["first": 3], type: .object(Course.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(banklessTokens: BanklessToken? = nil, poapTokens: PoapToken? = nil, bounties: Bounty? = nil, courses: Course? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "BanklessTokens": banklessTokens.flatMap { (value: BanklessToken) -> ResultMap in value.resultMap }, "POAPTokens": poapTokens.flatMap { (value: PoapToken) -> ResultMap in value.resultMap }, "Bounties": bounties.flatMap { (value: Bounty) -> ResultMap in value.resultMap }, "Courses": courses.flatMap { (value: Course) -> ResultMap in value.resultMap }])
    }

    public var banklessTokens: BanklessToken? {
      get {
        return (resultMap["BanklessTokens"] as? ResultMap).flatMap { BanklessToken(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "BanklessTokens")
      }
    }

    public var poapTokens: PoapToken? {
      get {
        return (resultMap["POAPTokens"] as? ResultMap).flatMap { PoapToken(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "POAPTokens")
      }
    }

    public var bounties: Bounty? {
      get {
        return (resultMap["Bounties"] as? ResultMap).flatMap { Bounty(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Bounties")
      }
    }

    public var courses: Course? {
      get {
        return (resultMap["Courses"] as? ResultMap).flatMap { Course(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Courses")
      }
    }

    public struct BanklessToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BanklessTokenResults"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "BanklessTokenResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessToken"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("address", type: .scalar(String.self)),
            GraphQLField("balance", type: .scalar(Double.self)),
            GraphQLField("transactions", type: .list(.object(Transaction.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(address: String? = nil, balance: Double? = nil, transactions: [Transaction?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "BanklessToken", "address": address, "balance": balance, "transactions": transactions.flatMap { (value: [Transaction?]) -> [ResultMap?] in value.map { (value: Transaction?) -> ResultMap? in value.flatMap { (value: Transaction) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var address: String? {
          get {
            return resultMap["address"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "address")
          }
        }

        public var balance: Double? {
          get {
            return resultMap["balance"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "balance")
          }
        }

        public var transactions: [Transaction?]? {
          get {
            return (resultMap["transactions"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Transaction?] in value.map { (value: ResultMap?) -> Transaction? in value.flatMap { (value: ResultMap) -> Transaction in Transaction(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Transaction?]) -> [ResultMap?] in value.map { (value: Transaction?) -> ResultMap? in value.flatMap { (value: Transaction) -> ResultMap in value.resultMap } } }, forKey: "transactions")
          }
        }

        public struct Transaction: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Transaction"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("amount", type: .scalar(Double.self)),
              GraphQLField("toAddress", type: .scalar(String.self)),
              GraphQLField("fromAddress", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(amount: Double? = nil, toAddress: String? = nil, fromAddress: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Transaction", "amount": amount, "toAddress": toAddress, "fromAddress": fromAddress])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var amount: Double? {
            get {
              return resultMap["amount"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "amount")
            }
          }

          public var toAddress: String? {
            get {
              return resultMap["toAddress"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "toAddress")
            }
          }

          public var fromAddress: String? {
            get {
              return resultMap["fromAddress"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "fromAddress")
            }
          }
        }
      }
    }

    public struct PoapToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["POAPTokenResults"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "POAPTokenResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["POAPToken"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("owner", type: .scalar(String.self)),
            GraphQLField("mintedAt", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, owner: String? = nil, mintedAt: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "POAPToken", "id": id, "owner": owner, "mintedAt": mintedAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var owner: String? {
          get {
            return resultMap["owner"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "owner")
          }
        }

        public var mintedAt: Double? {
          get {
            return resultMap["mintedAt"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "mintedAt")
          }
        }
      }
    }

    public struct Bounty: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["BountyResults"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "BountyResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Bounty"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("season", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("rewardAmount", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil, season: String? = nil, description: String? = nil, rewardAmount: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Bounty", "id": id, "title": title, "season": season, "description": description, "rewardAmount": rewardAmount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var season: String? {
          get {
            return resultMap["season"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "season")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var rewardAmount: Double? {
          get {
            return resultMap["rewardAmount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "rewardAmount")
          }
        }
      }
    }

    public struct Course: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CourseResults"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum]) {
        self.init(unsafeResultMap: ["__typename": "CourseResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var data: [Datum] {
        get {
          return (resultMap["data"] as! [ResultMap]).map { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum) -> ResultMap in value.resultMap }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Course"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("slug", type: .scalar(String.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("duration", type: .scalar(Double.self)),
            GraphQLField("difficulty", type: .scalar(String.self)),
            GraphQLField("description", type: .scalar(String.self)),
            GraphQLField("knowledgeRequirements", type: .scalar(String.self)),
            GraphQLField("learnings", type: .scalar(String.self)),
            GraphQLField("learningActions", type: .scalar(String.self)),
            GraphQLField("poapEventId", type: .scalar(Double.self)),
            GraphQLField("poapImageLink", type: .scalar(String.self)),
            GraphQLField("sections", type: .list(.object(Section.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(slug: String? = nil, name: String? = nil, duration: Double? = nil, difficulty: String? = nil, description: String? = nil, knowledgeRequirements: String? = nil, learnings: String? = nil, learningActions: String? = nil, poapEventId: Double? = nil, poapImageLink: String? = nil, sections: [Section?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Course", "slug": slug, "name": name, "duration": duration, "difficulty": difficulty, "description": description, "knowledgeRequirements": knowledgeRequirements, "learnings": learnings, "learningActions": learningActions, "poapEventId": poapEventId, "poapImageLink": poapImageLink, "sections": sections.flatMap { (value: [Section?]) -> [ResultMap?] in value.map { (value: Section?) -> ResultMap? in value.flatMap { (value: Section) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var slug: String? {
          get {
            return resultMap["slug"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "slug")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var duration: Double? {
          get {
            return resultMap["duration"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "duration")
          }
        }

        public var difficulty: String? {
          get {
            return resultMap["difficulty"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "difficulty")
          }
        }

        public var description: String? {
          get {
            return resultMap["description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "description")
          }
        }

        public var knowledgeRequirements: String? {
          get {
            return resultMap["knowledgeRequirements"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "knowledgeRequirements")
          }
        }

        public var learnings: String? {
          get {
            return resultMap["learnings"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "learnings")
          }
        }

        public var learningActions: String? {
          get {
            return resultMap["learningActions"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "learningActions")
          }
        }

        public var poapEventId: Double? {
          get {
            return resultMap["poapEventId"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "poapEventId")
          }
        }

        public var poapImageLink: String? {
          get {
            return resultMap["poapImageLink"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "poapImageLink")
          }
        }

        public var sections: [Section?]? {
          get {
            return (resultMap["sections"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Section?] in value.map { (value: ResultMap?) -> Section? in value.flatMap { (value: ResultMap) -> Section in Section(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Section?]) -> [ResultMap?] in value.map { (value: Section?) -> ResultMap? in value.flatMap { (value: Section) -> ResultMap in value.resultMap } } }, forKey: "sections")
          }
        }

        public struct Section: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Section"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .scalar(String.self)),
              GraphQLField("title", type: .scalar(String.self)),
              GraphQLField("content", type: .scalar(String.self)),
              GraphQLField("quiz", type: .object(Quiz.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(type: String? = nil, title: String? = nil, content: String? = nil, quiz: Quiz? = nil) {
            self.init(unsafeResultMap: ["__typename": "Section", "type": type, "title": title, "content": content, "quiz": quiz.flatMap { (value: Quiz) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var type: String? {
            get {
              return resultMap["type"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }

          public var title: String? {
            get {
              return resultMap["title"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          public var content: String? {
            get {
              return resultMap["content"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "content")
            }
          }

          public var quiz: Quiz? {
            get {
              return (resultMap["quiz"] as? ResultMap).flatMap { Quiz(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "quiz")
            }
          }

          public struct Quiz: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Quiz"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("answers", type: .list(.scalar(String.self))),
                GraphQLField("rightAnswerNumber", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(answers: [String?]? = nil, rightAnswerNumber: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Quiz", "answers": answers, "rightAnswerNumber": rightAnswerNumber])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var answers: [String?]? {
              get {
                return resultMap["answers"] as? [String?]
              }
              set {
                resultMap.updateValue(newValue, forKey: "answers")
              }
            }

            public var rightAnswerNumber: Double? {
              get {
                return resultMap["rightAnswerNumber"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "rightAnswerNumber")
              }
            }
          }
        }
      }
    }
  }
}

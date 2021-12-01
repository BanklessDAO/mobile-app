// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class BountyBoardQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query BountyBoard {
      historical {
        __typename
        BanklessBountyBoardV1 {
          __typename
          allBounties: Bounties {
            __typename
            data {
              __typename
              id
              title
              season
              description
              criteria
              reward {
                __typename
                currency
                scale
                amount
              }
              status
              createdBy {
                __typename
                discordHandle
                discordId
              }
              createdAt
              dueAt
              discordMessageId
              statusHistory {
                __typename
                setAt
                status
              }
              claimedBy {
                __typename
                discordHandle
                discordId
              }
              claimedAt
              submissionUrl
              submissionNotes
              submittedBy {
                __typename
                discordHandle
                discordId
              }
              submittedAt
              reviewedBy {
                __typename
                discordHandle
                discordId
              }
              reviewedAt
            }
          }
        }
      }
    }
    """

  public let operationName: String = "BountyBoard"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("historical", type: .nonNull(.object(Historical.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(historical: Historical) {
      self.init(unsafeResultMap: ["__typename": "Query", "historical": historical.resultMap])
    }

    /// Contains all the queries that operate on historical data that might not be up to date
    public var historical: Historical {
      get {
        return Historical(unsafeResultMap: resultMap["historical"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "historical")
      }
    }

    public struct Historical: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["historical"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("BanklessBountyBoardV1", type: .nonNull(.object(BanklessBountyBoardV1.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(banklessBountyBoardV1: BanklessBountyBoardV1) {
        self.init(unsafeResultMap: ["__typename": "historical", "BanklessBountyBoardV1": banklessBountyBoardV1.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var banklessBountyBoardV1: BanklessBountyBoardV1 {
        get {
          return BanklessBountyBoardV1(unsafeResultMap: resultMap["BanklessBountyBoardV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "BanklessBountyBoardV1")
        }
      }

      public struct BanklessBountyBoardV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessBountyBoardV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("Bounties", alias: "allBounties", type: .nonNull(.object(AllBounty.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(allBounties: AllBounty) {
          self.init(unsafeResultMap: ["__typename": "BanklessBountyBoardV1", "allBounties": allBounties.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of Bountys. Supports pagination and filtering.
        public var allBounties: AllBounty {
          get {
            return AllBounty(unsafeResultMap: resultMap["allBounties"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "allBounties")
          }
        }

        public struct AllBounty: GraphQLSelectionSet {
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

          /// Contains the results of the query.
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
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("title", type: .scalar(String.self)),
                GraphQLField("season", type: .scalar(Double.self)),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("criteria", type: .scalar(String.self)),
                GraphQLField("reward", type: .object(Reward.selections)),
                GraphQLField("status", type: .scalar(String.self)),
                GraphQLField("createdBy", type: .object(CreatedBy.selections)),
                GraphQLField("createdAt", type: .scalar(Double.self)),
                GraphQLField("dueAt", type: .scalar(Double.self)),
                GraphQLField("discordMessageId", type: .scalar(String.self)),
                GraphQLField("statusHistory", type: .list(.object(StatusHistory.selections))),
                GraphQLField("claimedBy", type: .object(ClaimedBy.selections)),
                GraphQLField("claimedAt", type: .scalar(Double.self)),
                GraphQLField("submissionUrl", type: .scalar(String.self)),
                GraphQLField("submissionNotes", type: .scalar(String.self)),
                GraphQLField("submittedBy", type: .object(SubmittedBy.selections)),
                GraphQLField("submittedAt", type: .scalar(Double.self)),
                GraphQLField("reviewedBy", type: .object(ReviewedBy.selections)),
                GraphQLField("reviewedAt", type: .scalar(Double.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, title: String? = nil, season: Double? = nil, description: String? = nil, criteria: String? = nil, reward: Reward? = nil, status: String? = nil, createdBy: CreatedBy? = nil, createdAt: Double? = nil, dueAt: Double? = nil, discordMessageId: String? = nil, statusHistory: [StatusHistory?]? = nil, claimedBy: ClaimedBy? = nil, claimedAt: Double? = nil, submissionUrl: String? = nil, submissionNotes: String? = nil, submittedBy: SubmittedBy? = nil, submittedAt: Double? = nil, reviewedBy: ReviewedBy? = nil, reviewedAt: Double? = nil) {
              self.init(unsafeResultMap: ["__typename": "Bounty", "id": id, "title": title, "season": season, "description": description, "criteria": criteria, "reward": reward.flatMap { (value: Reward) -> ResultMap in value.resultMap }, "status": status, "createdBy": createdBy.flatMap { (value: CreatedBy) -> ResultMap in value.resultMap }, "createdAt": createdAt, "dueAt": dueAt, "discordMessageId": discordMessageId, "statusHistory": statusHistory.flatMap { (value: [StatusHistory?]) -> [ResultMap?] in value.map { (value: StatusHistory?) -> ResultMap? in value.flatMap { (value: StatusHistory) -> ResultMap in value.resultMap } } }, "claimedBy": claimedBy.flatMap { (value: ClaimedBy) -> ResultMap in value.resultMap }, "claimedAt": claimedAt, "submissionUrl": submissionUrl, "submissionNotes": submissionNotes, "submittedBy": submittedBy.flatMap { (value: SubmittedBy) -> ResultMap in value.resultMap }, "submittedAt": submittedAt, "reviewedBy": reviewedBy.flatMap { (value: ReviewedBy) -> ResultMap in value.resultMap }, "reviewedAt": reviewedAt])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: String? {
              get {
                return resultMap["id"] as? String
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

            public var season: Double? {
              get {
                return resultMap["season"] as? Double
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

            public var criteria: String? {
              get {
                return resultMap["criteria"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "criteria")
              }
            }

            public var reward: Reward? {
              get {
                return (resultMap["reward"] as? ResultMap).flatMap { Reward(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "reward")
              }
            }

            public var status: String? {
              get {
                return resultMap["status"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "status")
              }
            }

            public var createdBy: CreatedBy? {
              get {
                return (resultMap["createdBy"] as? ResultMap).flatMap { CreatedBy(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "createdBy")
              }
            }

            public var createdAt: Double? {
              get {
                return resultMap["createdAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "createdAt")
              }
            }

            public var dueAt: Double? {
              get {
                return resultMap["dueAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "dueAt")
              }
            }

            public var discordMessageId: String? {
              get {
                return resultMap["discordMessageId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "discordMessageId")
              }
            }

            public var statusHistory: [StatusHistory?]? {
              get {
                return (resultMap["statusHistory"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [StatusHistory?] in value.map { (value: ResultMap?) -> StatusHistory? in value.flatMap { (value: ResultMap) -> StatusHistory in StatusHistory(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [StatusHistory?]) -> [ResultMap?] in value.map { (value: StatusHistory?) -> ResultMap? in value.flatMap { (value: StatusHistory) -> ResultMap in value.resultMap } } }, forKey: "statusHistory")
              }
            }

            public var claimedBy: ClaimedBy? {
              get {
                return (resultMap["claimedBy"] as? ResultMap).flatMap { ClaimedBy(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "claimedBy")
              }
            }

            public var claimedAt: Double? {
              get {
                return resultMap["claimedAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "claimedAt")
              }
            }

            public var submissionUrl: String? {
              get {
                return resultMap["submissionUrl"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "submissionUrl")
              }
            }

            public var submissionNotes: String? {
              get {
                return resultMap["submissionNotes"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "submissionNotes")
              }
            }

            public var submittedBy: SubmittedBy? {
              get {
                return (resultMap["submittedBy"] as? ResultMap).flatMap { SubmittedBy(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "submittedBy")
              }
            }

            public var submittedAt: Double? {
              get {
                return resultMap["submittedAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "submittedAt")
              }
            }

            public var reviewedBy: ReviewedBy? {
              get {
                return (resultMap["reviewedBy"] as? ResultMap).flatMap { ReviewedBy(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "reviewedBy")
              }
            }

            public var reviewedAt: Double? {
              get {
                return resultMap["reviewedAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "reviewedAt")
              }
            }

            public struct Reward: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Reward"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("currency", type: .scalar(String.self)),
                  GraphQLField("scale", type: .scalar(Double.self)),
                  GraphQLField("amount", type: .scalar(Double.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(currency: String? = nil, scale: Double? = nil, amount: Double? = nil) {
                self.init(unsafeResultMap: ["__typename": "Reward", "currency": currency, "scale": scale, "amount": amount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var currency: String? {
                get {
                  return resultMap["currency"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "currency")
                }
              }

              public var scale: Double? {
                get {
                  return resultMap["scale"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "scale")
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
            }

            public struct CreatedBy: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["DiscordUser"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("discordHandle", type: .scalar(String.self)),
                  GraphQLField("discordId", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(discordHandle: String? = nil, discordId: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "DiscordUser", "discordHandle": discordHandle, "discordId": discordId])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var discordHandle: String? {
                get {
                  return resultMap["discordHandle"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordHandle")
                }
              }

              public var discordId: String? {
                get {
                  return resultMap["discordId"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordId")
                }
              }
            }

            public struct StatusHistory: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["StatusEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("setAt", type: .scalar(Double.self)),
                  GraphQLField("status", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(setAt: Double? = nil, status: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "StatusEvent", "setAt": setAt, "status": status])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var setAt: Double? {
                get {
                  return resultMap["setAt"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "setAt")
                }
              }

              public var status: String? {
                get {
                  return resultMap["status"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "status")
                }
              }
            }

            public struct ClaimedBy: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["DiscordUser"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("discordHandle", type: .scalar(String.self)),
                  GraphQLField("discordId", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(discordHandle: String? = nil, discordId: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "DiscordUser", "discordHandle": discordHandle, "discordId": discordId])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var discordHandle: String? {
                get {
                  return resultMap["discordHandle"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordHandle")
                }
              }

              public var discordId: String? {
                get {
                  return resultMap["discordId"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordId")
                }
              }
            }

            public struct SubmittedBy: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["DiscordUser"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("discordHandle", type: .scalar(String.self)),
                  GraphQLField("discordId", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(discordHandle: String? = nil, discordId: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "DiscordUser", "discordHandle": discordHandle, "discordId": discordId])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var discordHandle: String? {
                get {
                  return resultMap["discordHandle"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordHandle")
                }
              }

              public var discordId: String? {
                get {
                  return resultMap["discordId"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordId")
                }
              }
            }

            public struct ReviewedBy: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["DiscordUser"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("discordHandle", type: .scalar(String.self)),
                  GraphQLField("discordId", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(discordHandle: String? = nil, discordId: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "DiscordUser", "discordHandle": discordHandle, "discordId": discordId])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var discordHandle: String? {
                get {
                  return resultMap["discordHandle"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordHandle")
                }
              }

              public var discordId: String? {
                get {
                  return resultMap["discordId"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "discordId")
                }
              }
            }
          }
        }
      }
    }
  }
}

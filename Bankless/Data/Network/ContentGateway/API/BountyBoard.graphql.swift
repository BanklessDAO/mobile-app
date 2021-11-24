// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class BountyBoardQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query BountyBoard {
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
    }
    """

  public let operationName: String = "BountyBoard"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Bounties", type: .object(Bounty.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(bounties: Bounty? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Bounties": bounties.flatMap { (value: Bounty) -> ResultMap in value.resultMap }])
    }

    public var bounties: Bounty? {
      get {
        return (resultMap["Bounties"] as? ResultMap).flatMap { Bounty(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Bounties")
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
  }
}

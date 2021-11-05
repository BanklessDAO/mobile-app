// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class SampleDataQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SampleData {
      poapEvent(id: "69") {
        __typename
        tokens {
          __typename
          owner {
            __typename
            id
          }
        }
      }
    }
    """

  public let operationName: String = "SampleData"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("poapEvent", arguments: ["id": "69"], type: .object(PoapEvent.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(poapEvent: PoapEvent? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "poapEvent": poapEvent.flatMap { (value: PoapEvent) -> ResultMap in value.resultMap }])
    }

    public var poapEvent: PoapEvent? {
      get {
        return (resultMap["poapEvent"] as? ResultMap).flatMap { PoapEvent(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "poapEvent")
      }
    }

    public struct PoapEvent: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PoapEvent"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("tokens", type: .nonNull(.list(.nonNull(.object(Token.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(tokens: [Token]) {
        self.init(unsafeResultMap: ["__typename": "PoapEvent", "tokens": tokens.map { (value: Token) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var tokens: [Token] {
        get {
          return (resultMap["tokens"] as! [ResultMap]).map { (value: ResultMap) -> Token in Token(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Token) -> ResultMap in value.resultMap }, forKey: "tokens")
        }
      }

      public struct Token: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Token"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(owner: Owner) {
          self.init(unsafeResultMap: ["__typename": "Token", "owner": owner.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var owner: Owner {
          get {
            return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "owner")
          }
        }

        public struct Owner: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Account"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID) {
            self.init(unsafeResultMap: ["__typename": "Account", "id": id])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }
        }
      }
    }
  }
}

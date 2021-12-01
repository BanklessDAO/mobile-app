// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class BankAccountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query BankAccount($ethAddress: String) {
      historical {
        __typename
        BanklessTokenV1 {
          __typename
          myAccount: BANKAccounts(where: {id: {equals: $ethAddress}}) {
            __typename
            data {
              __typename
              id
              balance
              lastTransactionExecutedAt
            }
          }
          fromTransfers: BANKTransfers(where: {fromId: {equals: $ethAddress}}) {
            __typename
            data {
              __typename
              fromId
              toId
              value
            }
          }
          toTransfers: BANKTransfers(where: {toId: {equals: $ethAddress}}) {
            __typename
            data {
              __typename
              fromId
              toId
              value
            }
          }
        }
      }
    }
    """

  public let operationName: String = "BankAccount"

  public var ethAddress: String?

  public init(ethAddress: String? = nil) {
    self.ethAddress = ethAddress
  }

  public var variables: GraphQLMap? {
    return ["ethAddress": ethAddress]
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
          GraphQLField("BanklessTokenV1", type: .nonNull(.object(BanklessTokenV1.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(banklessTokenV1: BanklessTokenV1) {
        self.init(unsafeResultMap: ["__typename": "historical", "BanklessTokenV1": banklessTokenV1.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var banklessTokenV1: BanklessTokenV1 {
        get {
          return BanklessTokenV1(unsafeResultMap: resultMap["BanklessTokenV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "BanklessTokenV1")
        }
      }

      public struct BanklessTokenV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessTokenV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BANKAccounts", alias: "myAccount", arguments: ["where": ["id": ["equals": GraphQLVariable("ethAddress")]]], type: .nonNull(.object(MyAccount.selections))),
            GraphQLField("BANKTransfers", alias: "fromTransfers", arguments: ["where": ["fromId": ["equals": GraphQLVariable("ethAddress")]]], type: .nonNull(.object(FromTransfer.selections))),
            GraphQLField("BANKTransfers", alias: "toTransfers", arguments: ["where": ["toId": ["equals": GraphQLVariable("ethAddress")]]], type: .nonNull(.object(ToTransfer.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(myAccount: MyAccount, fromTransfers: FromTransfer, toTransfers: ToTransfer) {
          self.init(unsafeResultMap: ["__typename": "BanklessTokenV1", "myAccount": myAccount.resultMap, "fromTransfers": fromTransfers.resultMap, "toTransfers": toTransfers.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of BANKAccounts. Supports pagination and filtering.
        public var myAccount: MyAccount {
          get {
            return MyAccount(unsafeResultMap: resultMap["myAccount"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "myAccount")
          }
        }

        /// Returns a list of BANKTransfers. Supports pagination and filtering.
        public var fromTransfers: FromTransfer {
          get {
            return FromTransfer(unsafeResultMap: resultMap["fromTransfers"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "fromTransfers")
          }
        }

        /// Returns a list of BANKTransfers. Supports pagination and filtering.
        public var toTransfers: ToTransfer {
          get {
            return ToTransfer(unsafeResultMap: resultMap["toTransfers"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "toTransfers")
          }
        }

        public struct MyAccount: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BANKAccountResults"]

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
            self.init(unsafeResultMap: ["__typename": "BANKAccountResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["BANKAccount"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("balance", type: .scalar(String.self)),
                GraphQLField("lastTransactionExecutedAt", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, balance: String? = nil, lastTransactionExecutedAt: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "BANKAccount", "id": id, "balance": balance, "lastTransactionExecutedAt": lastTransactionExecutedAt])
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

            public var balance: String? {
              get {
                return resultMap["balance"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "balance")
              }
            }

            public var lastTransactionExecutedAt: String? {
              get {
                return resultMap["lastTransactionExecutedAt"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "lastTransactionExecutedAt")
              }
            }
          }
        }

        public struct FromTransfer: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BANKTransferResults"]

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
            self.init(unsafeResultMap: ["__typename": "BANKTransferResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["BANKTransfer"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("fromId", type: .scalar(String.self)),
                GraphQLField("toId", type: .scalar(String.self)),
                GraphQLField("value", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(fromId: String? = nil, toId: String? = nil, value: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "BANKTransfer", "fromId": fromId, "toId": toId, "value": value])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fromId: String? {
              get {
                return resultMap["fromId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "fromId")
              }
            }

            public var toId: String? {
              get {
                return resultMap["toId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "toId")
              }
            }

            public var value: String? {
              get {
                return resultMap["value"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "value")
              }
            }
          }
        }

        public struct ToTransfer: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BANKTransferResults"]

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
            self.init(unsafeResultMap: ["__typename": "BANKTransferResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["BANKTransfer"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("fromId", type: .scalar(String.self)),
                GraphQLField("toId", type: .scalar(String.self)),
                GraphQLField("value", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(fromId: String? = nil, toId: String? = nil, value: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "BANKTransfer", "fromId": fromId, "toId": toId, "value": value])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var fromId: String? {
              get {
                return resultMap["fromId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "fromId")
              }
            }

            public var toId: String? {
              get {
                return resultMap["toId"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "toId")
              }
            }

            public var value: String? {
              get {
                return resultMap["value"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "value")
              }
            }
          }
        }
      }
    }
  }
}

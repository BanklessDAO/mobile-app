// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class BankAccountQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query BankAccount($ethAddress: ID!) {
      account(id: $ethAddress) {
        __typename
        id
        lastTransactionTimestamp
        ERC20balances {
          __typename
          value
          valueExact
        }
      }
    }
    """

  public let operationName: String = "BankAccount"

  public var ethAddress: GraphQLID

  public init(ethAddress: GraphQLID) {
    self.ethAddress = ethAddress
  }

  public var variables: GraphQLMap? {
    return ["ethAddress": ethAddress]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("account", arguments: ["id": GraphQLVariable("ethAddress")], type: .object(Account.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(account: Account? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "account": account.flatMap { (value: Account) -> ResultMap in value.resultMap }])
    }

    public var account: Account? {
      get {
        return (resultMap["account"] as? ResultMap).flatMap { Account(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "account")
      }
    }

    public struct Account: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("lastTransactionTimestamp", type: .nonNull(.scalar(String.self))),
          GraphQLField("ERC20balances", type: .nonNull(.list(.nonNull(.object(Erc20balance.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, lastTransactionTimestamp: String, erc20balances: [Erc20balance]) {
        self.init(unsafeResultMap: ["__typename": "Account", "id": id, "lastTransactionTimestamp": lastTransactionTimestamp, "ERC20balances": erc20balances.map { (value: Erc20balance) -> ResultMap in value.resultMap }])
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

      public var lastTransactionTimestamp: String {
        get {
          return resultMap["lastTransactionTimestamp"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastTransactionTimestamp")
        }
      }

      public var erc20balances: [Erc20balance] {
        get {
          return (resultMap["ERC20balances"] as! [ResultMap]).map { (value: ResultMap) -> Erc20balance in Erc20balance(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Erc20balance) -> ResultMap in value.resultMap }, forKey: "ERC20balances")
        }
      }

      public struct Erc20balance: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ERC20Balance"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("value", type: .nonNull(.scalar(String.self))),
            GraphQLField("valueExact", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(value: String, valueExact: String) {
          self.init(unsafeResultMap: ["__typename": "ERC20Balance", "value": value, "valueExact": valueExact])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var value: String {
          get {
            return resultMap["value"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "value")
          }
        }

        public var valueExact: String {
          get {
            return resultMap["valueExact"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "valueExact")
          }
        }
      }
    }
  }
}

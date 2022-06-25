// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class EnsNameQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ENSName($ethAddress: String) {
      domains(where: {resolvedAddress_contains: $ethAddress, name_contains: ".eth"}) {
        __typename
        id
        name
        resolvedAddress {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "ENSName"

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
        GraphQLField("domains", arguments: ["where": ["resolvedAddress_contains": GraphQLVariable("ethAddress"), "name_contains": ".eth"]], type: .nonNull(.list(.nonNull(.object(Domain.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(domains: [Domain]) {
      self.init(unsafeResultMap: ["__typename": "Query", "domains": domains.map { (value: Domain) -> ResultMap in value.resultMap }])
    }

    public var domains: [Domain] {
      get {
        return (resultMap["domains"] as! [ResultMap]).map { (value: ResultMap) -> Domain in Domain(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Domain) -> ResultMap in value.resultMap }, forKey: "domains")
      }
    }

    public struct Domain: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Domain"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("resolvedAddress", type: .object(ResolvedAddress.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, resolvedAddress: ResolvedAddress? = nil) {
        self.init(unsafeResultMap: ["__typename": "Domain", "id": id, "name": name, "resolvedAddress": resolvedAddress.flatMap { (value: ResolvedAddress) -> ResultMap in value.resultMap }])
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

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var resolvedAddress: ResolvedAddress? {
        get {
          return (resultMap["resolvedAddress"] as? ResultMap).flatMap { ResolvedAddress(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "resolvedAddress")
        }
      }

      public struct ResolvedAddress: GraphQLSelectionSet {
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

public final class EnsAddressQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ENSAddress($ensName: String) {
      domains(where: {name_contains: $ensName}) {
        __typename
        id
        name
        resolvedAddress {
          __typename
          id
        }
      }
    }
    """

  public let operationName: String = "ENSAddress"

  public var ensName: String?

  public init(ensName: String? = nil) {
    self.ensName = ensName
  }

  public var variables: GraphQLMap? {
    return ["ensName": ensName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("domains", arguments: ["where": ["name_contains": GraphQLVariable("ensName")]], type: .nonNull(.list(.nonNull(.object(Domain.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(domains: [Domain]) {
      self.init(unsafeResultMap: ["__typename": "Query", "domains": domains.map { (value: Domain) -> ResultMap in value.resultMap }])
    }

    public var domains: [Domain] {
      get {
        return (resultMap["domains"] as! [ResultMap]).map { (value: ResultMap) -> Domain in Domain(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Domain) -> ResultMap in value.resultMap }, forKey: "domains")
      }
    }

    public struct Domain: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Domain"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("resolvedAddress", type: .object(ResolvedAddress.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, resolvedAddress: ResolvedAddress? = nil) {
        self.init(unsafeResultMap: ["__typename": "Domain", "id": id, "name": name, "resolvedAddress": resolvedAddress.flatMap { (value: ResolvedAddress) -> ResultMap in value.resultMap }])
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

      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var resolvedAddress: ResolvedAddress? {
        get {
          return (resultMap["resolvedAddress"] as? ResultMap).flatMap { ResolvedAddress(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "resolvedAddress")
        }
      }

      public struct ResolvedAddress: GraphQLSelectionSet {
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

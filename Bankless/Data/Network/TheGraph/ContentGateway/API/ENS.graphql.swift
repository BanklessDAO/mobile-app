// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class EnsNameQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ENSName($ethAddress: String) {
      historical {
        __typename
        EnsV1 {
          __typename
          EnsDomainV1s(where: {address: {equals: $ethAddress}}) {
            __typename
            data {
              __typename
              id
              createdAt
              name
              address
            }
          }
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
          GraphQLField("EnsV1", type: .nonNull(.object(EnsV1.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ensV1: EnsV1) {
        self.init(unsafeResultMap: ["__typename": "historical", "EnsV1": ensV1.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ensV1: EnsV1 {
        get {
          return EnsV1(unsafeResultMap: resultMap["EnsV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "EnsV1")
        }
      }

      public struct EnsV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EnsV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("EnsDomainV1s", arguments: ["where": ["address": ["equals": GraphQLVariable("ethAddress")]]], type: .nonNull(.object(EnsDomainV1.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(ensDomainV1s: EnsDomainV1) {
          self.init(unsafeResultMap: ["__typename": "EnsV1", "EnsDomainV1s": ensDomainV1s.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of EnsDomainV1s. Supports pagination and filtering.
        public var ensDomainV1s: EnsDomainV1 {
          get {
            return EnsDomainV1(unsafeResultMap: resultMap["EnsDomainV1s"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "EnsDomainV1s")
          }
        }

        public struct EnsDomainV1: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EnsDomainV1Results"]

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
            self.init(unsafeResultMap: ["__typename": "EnsDomainV1Results", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["EnsDomainV1"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("createdAt", type: .scalar(String.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("address", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, createdAt: String? = nil, name: String? = nil, address: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "EnsDomainV1", "id": id, "createdAt": createdAt, "name": name, "address": address])
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

            public var createdAt: String? {
              get {
                return resultMap["createdAt"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "createdAt")
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

            public var address: String? {
              get {
                return resultMap["address"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "address")
              }
            }
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
      historical {
        __typename
        EnsV1 {
          __typename
          EnsDomainV1s(where: {name: {equals: $ensName}}) {
            __typename
            data {
              __typename
              id
              createdAt
              name
              address
            }
          }
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
          GraphQLField("EnsV1", type: .nonNull(.object(EnsV1.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ensV1: EnsV1) {
        self.init(unsafeResultMap: ["__typename": "historical", "EnsV1": ensV1.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ensV1: EnsV1 {
        get {
          return EnsV1(unsafeResultMap: resultMap["EnsV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "EnsV1")
        }
      }

      public struct EnsV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EnsV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("EnsDomainV1s", arguments: ["where": ["name": ["equals": GraphQLVariable("ensName")]]], type: .nonNull(.object(EnsDomainV1.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(ensDomainV1s: EnsDomainV1) {
          self.init(unsafeResultMap: ["__typename": "EnsV1", "EnsDomainV1s": ensDomainV1s.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of EnsDomainV1s. Supports pagination and filtering.
        public var ensDomainV1s: EnsDomainV1 {
          get {
            return EnsDomainV1(unsafeResultMap: resultMap["EnsDomainV1s"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "EnsDomainV1s")
          }
        }

        public struct EnsDomainV1: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EnsDomainV1Results"]

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
            self.init(unsafeResultMap: ["__typename": "EnsDomainV1Results", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["EnsDomainV1"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("createdAt", type: .scalar(String.self)),
                GraphQLField("name", type: .scalar(String.self)),
                GraphQLField("address", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, createdAt: String? = nil, name: String? = nil, address: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "EnsDomainV1", "id": id, "createdAt": createdAt, "name": name, "address": address])
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

            public var createdAt: String? {
              get {
                return resultMap["createdAt"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "createdAt")
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

            public var address: String? {
              get {
                return resultMap["address"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "address")
              }
            }
          }
        }
      }
    }
  }
}

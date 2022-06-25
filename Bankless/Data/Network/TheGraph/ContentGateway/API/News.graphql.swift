// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class NewsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query News($lastPodcastId: String, $lastWebsitePostId: String) {
      historical {
        __typename
        BanklessPodcastV1 {
          __typename
          playlist: BanklessPodcastPodcastV1s(
            orderBy: {fieldPath: "snippet.publishedAt", direction: desc}
            after: $lastPodcastId
          ) {
            __typename
            pageInfo {
              __typename
              hasNextPage
              nextPageToken
            }
            data {
              __typename
              id
              contentDetails {
                __typename
                videoId
                videoPublishedAt
              }
              snippet {
                __typename
                publishedAt
                thumbnails {
                  __typename
                  kind
                  url
                }
                title
                description
              }
            }
          }
        }
        BanklessWebsiteV1 {
          __typename
          posts: BanklessWebsitePostV1s(
            orderBy: {fieldPath: "publishedAt", direction: desc}
            after: $lastWebsitePostId
          ) {
            __typename
            pageInfo {
              __typename
              hasNextPage
              nextPageToken
            }
            data {
              __typename
              id
              title
              slug
              excerpt
              createdAt
              updatedAt
              featureImage
              url
              html
              readingTime
              featured
            }
          }
        }
      }
    }
    """

  public let operationName: String = "News"

  public var lastPodcastId: String?
  public var lastWebsitePostId: String?

  public init(lastPodcastId: String? = nil, lastWebsitePostId: String? = nil) {
    self.lastPodcastId = lastPodcastId
    self.lastWebsitePostId = lastWebsitePostId
  }

  public var variables: GraphQLMap? {
    return ["lastPodcastId": lastPodcastId, "lastWebsitePostId": lastWebsitePostId]
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
          GraphQLField("BanklessPodcastV1", type: .nonNull(.object(BanklessPodcastV1.selections))),
          GraphQLField("BanklessWebsiteV1", type: .nonNull(.object(BanklessWebsiteV1.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(banklessPodcastV1: BanklessPodcastV1, banklessWebsiteV1: BanklessWebsiteV1) {
        self.init(unsafeResultMap: ["__typename": "historical", "BanklessPodcastV1": banklessPodcastV1.resultMap, "BanklessWebsiteV1": banklessWebsiteV1.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var banklessPodcastV1: BanklessPodcastV1 {
        get {
          return BanklessPodcastV1(unsafeResultMap: resultMap["BanklessPodcastV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "BanklessPodcastV1")
        }
      }

      public var banklessWebsiteV1: BanklessWebsiteV1 {
        get {
          return BanklessWebsiteV1(unsafeResultMap: resultMap["BanklessWebsiteV1"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "BanklessWebsiteV1")
        }
      }

      public struct BanklessPodcastV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessPodcastV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BanklessPodcastPodcastV1s", alias: "playlist", arguments: ["orderBy": ["fieldPath": "snippet.publishedAt", "direction": "desc"], "after": GraphQLVariable("lastPodcastId")], type: .nonNull(.object(Playlist.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(playlist: Playlist) {
          self.init(unsafeResultMap: ["__typename": "BanklessPodcastV1", "playlist": playlist.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of BanklessPodcastPodcastV1s. Supports pagination and filtering.
        public var playlist: Playlist {
          get {
            return Playlist(unsafeResultMap: resultMap["playlist"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "playlist")
          }
        }

        public struct Playlist: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BanklessPodcastPodcastV1Results"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
              GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(pageInfo: PageInfo, data: [Datum]) {
            self.init(unsafeResultMap: ["__typename": "BanklessPodcastPodcastV1Results", "pageInfo": pageInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Contains information necessary for pagination
          public var pageInfo: PageInfo {
            get {
              return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
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

          public struct PageInfo: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("nextPageToken", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(hasNextPage: Bool, nextPageToken: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "nextPageToken": nextPageToken])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Tells whether there are more pages after the current one.
            public var hasNextPage: Bool {
              get {
                return resultMap["hasNextPage"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "hasNextPage")
              }
            }

            /// Pass this token in your next query as the value for the `after` parameter to access the next page.
            public var nextPageToken: String? {
              get {
                return resultMap["nextPageToken"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nextPageToken")
              }
            }
          }

          public struct Datum: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["BanklessPodcastPodcastV1"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("contentDetails", type: .object(ContentDetail.selections)),
                GraphQLField("snippet", type: .object(Snippet.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, contentDetails: ContentDetail? = nil, snippet: Snippet? = nil) {
              self.init(unsafeResultMap: ["__typename": "BanklessPodcastPodcastV1", "id": id, "contentDetails": contentDetails.flatMap { (value: ContentDetail) -> ResultMap in value.resultMap }, "snippet": snippet.flatMap { (value: Snippet) -> ResultMap in value.resultMap }])
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

            public var contentDetails: ContentDetail? {
              get {
                return (resultMap["contentDetails"] as? ResultMap).flatMap { ContentDetail(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "contentDetails")
              }
            }

            public var snippet: Snippet? {
              get {
                return (resultMap["snippet"] as? ResultMap).flatMap { Snippet(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "snippet")
              }
            }

            public struct ContentDetail: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["BanklessPodcastContentDetailsV1"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("videoId", type: .scalar(String.self)),
                  GraphQLField("videoPublishedAt", type: .scalar(Double.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(videoId: String? = nil, videoPublishedAt: Double? = nil) {
                self.init(unsafeResultMap: ["__typename": "BanklessPodcastContentDetailsV1", "videoId": videoId, "videoPublishedAt": videoPublishedAt])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var videoId: String? {
                get {
                  return resultMap["videoId"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "videoId")
                }
              }

              public var videoPublishedAt: Double? {
                get {
                  return resultMap["videoPublishedAt"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "videoPublishedAt")
                }
              }
            }

            public struct Snippet: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["BanklessPodcastSnippetV1"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("publishedAt", type: .scalar(Double.self)),
                  GraphQLField("thumbnails", type: .list(.object(Thumbnail.selections))),
                  GraphQLField("title", type: .scalar(String.self)),
                  GraphQLField("description", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(publishedAt: Double? = nil, thumbnails: [Thumbnail?]? = nil, title: String? = nil, description: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "BanklessPodcastSnippetV1", "publishedAt": publishedAt, "thumbnails": thumbnails.flatMap { (value: [Thumbnail?]) -> [ResultMap?] in value.map { (value: Thumbnail?) -> ResultMap? in value.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap } } }, "title": title, "description": description])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var publishedAt: Double? {
                get {
                  return resultMap["publishedAt"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "publishedAt")
                }
              }

              public var thumbnails: [Thumbnail?]? {
                get {
                  return (resultMap["thumbnails"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Thumbnail?] in value.map { (value: ResultMap?) -> Thumbnail? in value.flatMap { (value: ResultMap) -> Thumbnail in Thumbnail(unsafeResultMap: value) } } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [Thumbnail?]) -> [ResultMap?] in value.map { (value: Thumbnail?) -> ResultMap? in value.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap } } }, forKey: "thumbnails")
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

              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }

              public struct Thumbnail: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["BanklessPodcastThumbnailV1"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("kind", type: .scalar(String.self)),
                    GraphQLField("url", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(kind: String? = nil, url: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "BanklessPodcastThumbnailV1", "kind": kind, "url": url])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var kind: String? {
                  get {
                    return resultMap["kind"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "kind")
                  }
                }

                public var url: String? {
                  get {
                    return resultMap["url"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "url")
                  }
                }
              }
            }
          }
        }
      }

      public struct BanklessWebsiteV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessWebsiteV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BanklessWebsitePostV1s", alias: "posts", arguments: ["orderBy": ["fieldPath": "publishedAt", "direction": "desc"], "after": GraphQLVariable("lastWebsitePostId")], type: .nonNull(.object(Post.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(posts: Post) {
          self.init(unsafeResultMap: ["__typename": "BanklessWebsiteV1", "posts": posts.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of BanklessWebsitePostV1s. Supports pagination and filtering.
        public var posts: Post {
          get {
            return Post(unsafeResultMap: resultMap["posts"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "posts")
          }
        }

        public struct Post: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BanklessWebsitePostV1Results"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
              GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(pageInfo: PageInfo, data: [Datum]) {
            self.init(unsafeResultMap: ["__typename": "BanklessWebsitePostV1Results", "pageInfo": pageInfo.resultMap, "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Contains information necessary for pagination
          public var pageInfo: PageInfo {
            get {
              return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
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

          public struct PageInfo: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PageInfo"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("nextPageToken", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(hasNextPage: Bool, nextPageToken: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "nextPageToken": nextPageToken])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Tells whether there are more pages after the current one.
            public var hasNextPage: Bool {
              get {
                return resultMap["hasNextPage"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "hasNextPage")
              }
            }

            /// Pass this token in your next query as the value for the `after` parameter to access the next page.
            public var nextPageToken: String? {
              get {
                return resultMap["nextPageToken"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nextPageToken")
              }
            }
          }

          public struct Datum: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["BanklessWebsitePostV1"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("title", type: .scalar(String.self)),
                GraphQLField("slug", type: .scalar(String.self)),
                GraphQLField("excerpt", type: .scalar(String.self)),
                GraphQLField("createdAt", type: .scalar(Double.self)),
                GraphQLField("updatedAt", type: .scalar(Double.self)),
                GraphQLField("featureImage", type: .scalar(String.self)),
                GraphQLField("url", type: .scalar(String.self)),
                GraphQLField("html", type: .scalar(String.self)),
                GraphQLField("readingTime", type: .scalar(Double.self)),
                GraphQLField("featured", type: .scalar(Bool.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, title: String? = nil, slug: String? = nil, excerpt: String? = nil, createdAt: Double? = nil, updatedAt: Double? = nil, featureImage: String? = nil, url: String? = nil, html: String? = nil, readingTime: Double? = nil, featured: Bool? = nil) {
              self.init(unsafeResultMap: ["__typename": "BanklessWebsitePostV1", "id": id, "title": title, "slug": slug, "excerpt": excerpt, "createdAt": createdAt, "updatedAt": updatedAt, "featureImage": featureImage, "url": url, "html": html, "readingTime": readingTime, "featured": featured])
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

            public var slug: String? {
              get {
                return resultMap["slug"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "slug")
              }
            }

            public var excerpt: String? {
              get {
                return resultMap["excerpt"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "excerpt")
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

            public var updatedAt: Double? {
              get {
                return resultMap["updatedAt"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "updatedAt")
              }
            }

            public var featureImage: String? {
              get {
                return resultMap["featureImage"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "featureImage")
              }
            }

            public var url: String? {
              get {
                return resultMap["url"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "url")
              }
            }

            public var html: String? {
              get {
                return resultMap["html"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "html")
              }
            }

            public var readingTime: Double? {
              get {
                return resultMap["readingTime"] as? Double
              }
              set {
                resultMap.updateValue(newValue, forKey: "readingTime")
              }
            }

            public var featured: Bool? {
              get {
                return resultMap["featured"] as? Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "featured")
              }
            }
          }
        }
      }
    }
  }
}

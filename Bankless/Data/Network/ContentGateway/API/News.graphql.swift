// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class NewsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query News {
      historical {
        __typename
        BanklessPodcastV1 {
          __typename
          playlist: Podcasts {
            __typename
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
          posts {
            __typename
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
            GraphQLField("Podcasts", alias: "playlist", type: .nonNull(.object(Playlist.selections))),
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

        /// Returns a list of Podcasts. Supports pagination and filtering.
        public var playlist: Playlist {
          get {
            return Playlist(unsafeResultMap: resultMap["playlist"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "playlist")
          }
        }

        public struct Playlist: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PodcastResults"]

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
            self.init(unsafeResultMap: ["__typename": "PodcastResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["Podcast"]

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
              self.init(unsafeResultMap: ["__typename": "Podcast", "id": id, "contentDetails": contentDetails.flatMap { (value: ContentDetail) -> ResultMap in value.resultMap }, "snippet": snippet.flatMap { (value: Snippet) -> ResultMap in value.resultMap }])
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
              public static let possibleTypes: [String] = ["ContentDetails"]

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
                self.init(unsafeResultMap: ["__typename": "ContentDetails", "videoId": videoId, "videoPublishedAt": videoPublishedAt])
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
              public static let possibleTypes: [String] = ["Snippet"]

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
                self.init(unsafeResultMap: ["__typename": "Snippet", "publishedAt": publishedAt, "thumbnails": thumbnails.flatMap { (value: [Thumbnail?]) -> [ResultMap?] in value.map { (value: Thumbnail?) -> ResultMap? in value.flatMap { (value: Thumbnail) -> ResultMap in value.resultMap } } }, "title": title, "description": description])
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
                public static let possibleTypes: [String] = ["Thumbnail"]

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
                  self.init(unsafeResultMap: ["__typename": "Thumbnail", "kind": kind, "url": url])
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
            GraphQLField("posts", type: .nonNull(.object(Post.selections))),
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

        /// Returns a list of posts. Supports pagination and filtering.
        public var posts: Post {
          get {
            return Post(unsafeResultMap: resultMap["posts"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "posts")
          }
        }

        public struct Post: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["postResults"]

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
            self.init(unsafeResultMap: ["__typename": "postResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["post"]

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
              self.init(unsafeResultMap: ["__typename": "post", "id": id, "title": title, "slug": slug, "excerpt": excerpt, "createdAt": createdAt, "updatedAt": updatedAt, "featureImage": featureImage, "url": url, "html": html, "readingTime": readingTime, "featured": featured])
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

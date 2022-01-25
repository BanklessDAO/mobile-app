// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class TimelineQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Timeline {
      historical {
        __typename
        BanklessPodcastV1 {
          __typename
          playlist: BanklessPodcastPodcastV1s(
            orderBy: {fieldPath: "snippet.publishedAt", direction: desc}
            first: 3
          ) {
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
          posts: BanklessWebsitePostV1s(
            orderBy: {fieldPath: "publishedAt", direction: desc}
            first: 3
          ) {
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
        BanklessAcademyV4 {
          __typename
          allCourses: BanklessAcademyCourseV4s(first: 3) {
            __typename
            data {
              __typename
              id
              lessonImageLink
              marketingDescription
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
              slides {
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
          GraphQLField("BanklessAcademyV4", type: .nonNull(.object(BanklessAcademyV4.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(banklessPodcastV1: BanklessPodcastV1, banklessWebsiteV1: BanklessWebsiteV1, banklessAcademyV4: BanklessAcademyV4) {
        self.init(unsafeResultMap: ["__typename": "historical", "BanklessPodcastV1": banklessPodcastV1.resultMap, "BanklessWebsiteV1": banklessWebsiteV1.resultMap, "BanklessAcademyV4": banklessAcademyV4.resultMap])
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

      public var banklessAcademyV4: BanklessAcademyV4 {
        get {
          return BanklessAcademyV4(unsafeResultMap: resultMap["BanklessAcademyV4"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "BanklessAcademyV4")
        }
      }

      public struct BanklessPodcastV1: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessPodcastV1"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BanklessPodcastPodcastV1s", alias: "playlist", arguments: ["orderBy": ["fieldPath": "snippet.publishedAt", "direction": "desc"], "first": 3], type: .nonNull(.object(Playlist.selections))),
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
              GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(data: [Datum]) {
            self.init(unsafeResultMap: ["__typename": "BanklessPodcastPodcastV1Results", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            GraphQLField("BanklessWebsitePostV1s", alias: "posts", arguments: ["orderBy": ["fieldPath": "publishedAt", "direction": "desc"], "first": 3], type: .nonNull(.object(Post.selections))),
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
              GraphQLField("data", type: .nonNull(.list(.nonNull(.object(Datum.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(data: [Datum]) {
            self.init(unsafeResultMap: ["__typename": "BanklessWebsitePostV1Results", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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

      public struct BanklessAcademyV4: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessAcademyV4"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BanklessAcademyCourseV4s", alias: "allCourses", arguments: ["first": 3], type: .nonNull(.object(AllCourse.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(allCourses: AllCourse) {
          self.init(unsafeResultMap: ["__typename": "BanklessAcademyV4", "allCourses": allCourses.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Returns a list of BanklessAcademyCourseV4s. Supports pagination and filtering.
        public var allCourses: AllCourse {
          get {
            return AllCourse(unsafeResultMap: resultMap["allCourses"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "allCourses")
          }
        }

        public struct AllCourse: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BanklessAcademyCourseV4Results"]

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
            self.init(unsafeResultMap: ["__typename": "BanklessAcademyCourseV4Results", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["BanklessAcademyCourseV4"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .scalar(String.self)),
                GraphQLField("lessonImageLink", type: .scalar(String.self)),
                GraphQLField("marketingDescription", type: .scalar(String.self)),
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
                GraphQLField("slides", type: .list(.object(Slide.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: String? = nil, lessonImageLink: String? = nil, marketingDescription: String? = nil, slug: String? = nil, name: String? = nil, duration: Double? = nil, difficulty: String? = nil, description: String? = nil, knowledgeRequirements: String? = nil, learnings: String? = nil, learningActions: String? = nil, poapEventId: Double? = nil, poapImageLink: String? = nil, slides: [Slide?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "BanklessAcademyCourseV4", "id": id, "lessonImageLink": lessonImageLink, "marketingDescription": marketingDescription, "slug": slug, "name": name, "duration": duration, "difficulty": difficulty, "description": description, "knowledgeRequirements": knowledgeRequirements, "learnings": learnings, "learningActions": learningActions, "poapEventId": poapEventId, "poapImageLink": poapImageLink, "slides": slides.flatMap { (value: [Slide?]) -> [ResultMap?] in value.map { (value: Slide?) -> ResultMap? in value.flatMap { (value: Slide) -> ResultMap in value.resultMap } } }])
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

            public var lessonImageLink: String? {
              get {
                return resultMap["lessonImageLink"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "lessonImageLink")
              }
            }

            public var marketingDescription: String? {
              get {
                return resultMap["marketingDescription"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "marketingDescription")
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

            public var slides: [Slide?]? {
              get {
                return (resultMap["slides"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Slide?] in value.map { (value: ResultMap?) -> Slide? in value.flatMap { (value: ResultMap) -> Slide in Slide(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Slide?]) -> [ResultMap?] in value.map { (value: Slide?) -> ResultMap? in value.flatMap { (value: Slide) -> ResultMap in value.resultMap } } }, forKey: "slides")
              }
            }

            public struct Slide: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["BanklessAcademySlideV4"]

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
                self.init(unsafeResultMap: ["__typename": "BanklessAcademySlideV4", "type": type, "title": title, "content": content, "quiz": quiz.flatMap { (value: Quiz) -> ResultMap in value.resultMap }])
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
                public static let possibleTypes: [String] = ["BanklessAcademyQuizV4"]

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
                  self.init(unsafeResultMap: ["__typename": "BanklessAcademyQuizV4", "answers": answers, "rightAnswerNumber": rightAnswerNumber])
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
  }
}

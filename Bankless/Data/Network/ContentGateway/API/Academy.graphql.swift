// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AcademyQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Academy {
      historical {
        __typename
        BanklessAcademyV4 {
          __typename
          allCourses: BanklessAcademyCourseV4s {
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

  public let operationName: String = "Academy"

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
          GraphQLField("BanklessAcademyV4", type: .nonNull(.object(BanklessAcademyV4.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(banklessAcademyV4: BanklessAcademyV4) {
        self.init(unsafeResultMap: ["__typename": "historical", "BanklessAcademyV4": banklessAcademyV4.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public struct BanklessAcademyV4: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BanklessAcademyV4"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("BanklessAcademyCourseV4s", alias: "allCourses", type: .nonNull(.object(AllCourse.selections))),
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

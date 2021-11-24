// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AcademyQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Academy {
      Courses {
        __typename
        data {
          __typename
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
          sections {
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
    """

  public let operationName: String = "Academy"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("Courses", type: .object(Course.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(courses: Course? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "Courses": courses.flatMap { (value: Course) -> ResultMap in value.resultMap }])
    }

    public var courses: Course? {
      get {
        return (resultMap["Courses"] as? ResultMap).flatMap { Course(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "Courses")
      }
    }

    public struct Course: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CourseResults"]

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
        self.init(unsafeResultMap: ["__typename": "CourseResults", "data": data.map { (value: Datum) -> ResultMap in value.resultMap }])
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
        public static let possibleTypes: [String] = ["Course"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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
            GraphQLField("sections", type: .list(.object(Section.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(slug: String? = nil, name: String? = nil, duration: Double? = nil, difficulty: String? = nil, description: String? = nil, knowledgeRequirements: String? = nil, learnings: String? = nil, learningActions: String? = nil, poapEventId: Double? = nil, poapImageLink: String? = nil, sections: [Section?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Course", "slug": slug, "name": name, "duration": duration, "difficulty": difficulty, "description": description, "knowledgeRequirements": knowledgeRequirements, "learnings": learnings, "learningActions": learningActions, "poapEventId": poapEventId, "poapImageLink": poapImageLink, "sections": sections.flatMap { (value: [Section?]) -> [ResultMap?] in value.map { (value: Section?) -> ResultMap? in value.flatMap { (value: Section) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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

        public var sections: [Section?]? {
          get {
            return (resultMap["sections"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Section?] in value.map { (value: ResultMap?) -> Section? in value.flatMap { (value: ResultMap) -> Section in Section(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Section?]) -> [ResultMap?] in value.map { (value: Section?) -> ResultMap? in value.flatMap { (value: Section) -> ResultMap in value.resultMap } } }, forKey: "sections")
          }
        }

        public struct Section: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Section"]

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
            self.init(unsafeResultMap: ["__typename": "Section", "type": type, "title": title, "content": content, "quiz": quiz.flatMap { (value: Quiz) -> ResultMap in value.resultMap }])
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
            public static let possibleTypes: [String] = ["Quiz"]

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
              self.init(unsafeResultMap: ["__typename": "Quiz", "answers": answers, "rightAnswerNumber": rightAnswerNumber])
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

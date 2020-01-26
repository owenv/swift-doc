// TODO: There's a lot of additional information available in the JSON format
// isn't represented here.
public struct SymbolGraph: Decodable {
  public struct Version: Decodable {
    public let major: Int
    public let minor: Int
    public let patch: Int
  }

  public struct Metadata: Decodable {
    public let formatVersion: Version
    public let generator: String
  }

  public struct Module: Decodable {
    public struct Platform: Decodable {
      public struct OperatingSystem: Decodable {
        public let name: String
        public let minimumVersion: Version
      }

      public let architecture: String
      public let vendor: String
      public let operatingSystem: OperatingSystem
    }

    public let name: String
    public let platform: Platform
  }

  public let metadata: Metadata
  public let module: Module
  public let symbols: [Symbol]
  private let relationships: [Edge]

  public func lookupSymbol(mangledName: String) -> Symbol? {
    return symbols.filter { $0.identifier.mangledName == mangledName }.first
  }

  public func outgoingEdges(for symbol: Symbol, kind: Edge.Kind? = nil) -> [Edge] {
    return relationships.filter {
      guard $0.sourceMangledName == symbol.identifier.mangledName else { return false }
      if let kind = kind {
        guard $0.kind == kind else { return false }
      }
      return true
    }
  }
}

extension SymbolGraph {
  public struct Symbol: Decodable {
    public enum Kind: String, Decodable, CustomStringConvertible {
      case `class` = "swift.class"
      case `struct` = "swift.struct"
      case `enum` = "swift.enum"
      case enumCase = "swift.enum.case"
      case `protocol` = "swift.protocol"
      case initializer = "swift.initializer"
      case function = "swift.function"
      case variable = "swift.variable"
      case `typealias` = "swift.typealias"
      case infixOperator = "swift.infixOperator"
      case prefixOperator = "swift.prefixOperator"
      case postfixOperator = "swift.postfixOperator"

      public var description: String {
        switch self {
        case .class:
          return "Class"
        case .struct:
          return "Struct"
        case .enum:
          return "Enum"
        case .enumCase:
          return "Enum Case"
        case .protocol:
          return "Protocol"
        case .initializer:
          return "Initializer"
        case .function:
          return "Function"
        case .variable:
          return "Variable"
        case .typealias:
          return "Typealias"
        case .infixOperator:
          return "Infix Operator"
        case .prefixOperator:
          return "Prefix Operator"
        case .postfixOperator:
          return "Postfix Operator"
        }
      }

      enum CodingKeys: String, CodingKey {
        case identifier
        case displayName
      }

      public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard let value = Kind(rawValue: try values.decode(String.self, forKey: .identifier)) else {
          throw DecodingError.typeMismatch(Kind.self, DecodingError.Context(codingPath: values.codingPath + [CodingKeys.identifier], debugDescription: ""))
        }
        self = value
      }

    }

    public struct Identifier: Decodable, Hashable {
      public let mangledName: String
      public let displayNameComponents: [String]

      enum CodingKeys: String, CodingKey {
        case mangledName = "precise"
        case displayNameComponents = "simpleComponents"
      }
    }

    public struct DocComment: Decodable {
      public let lines: [String]

      enum CodingKeys: String, CodingKey {
        case lines
      }

      public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let value = try values.decode([[String: String]].self, forKey: .lines)
        lines = value.compactMap { $0["text"] }
      }
    }

    public let kind: Kind
    public let identifier: Identifier
    public let docComment: DocComment

    public var displayName: String {
      identifier.displayNameComponents.joined(separator: ".")
    }
  }
}

extension SymbolGraph {
  public struct Edge: Decodable {
    public enum Kind: String, Decodable, CustomStringConvertible {
      case memberOf
      case conformsTo
      case inheritsFrom
      case defaultImplementationOf
      case overrides
      case requirementOf
      case optionalRequirementOf

      public var description: String {
        switch self {
        case .memberOf:
          return "Member of"
        case .conformsTo:
          return "Conforms to"
        case .inheritsFrom:
          return "Inherits from"
        case .defaultImplementationOf:
          return "Default implementation of"
        case .overrides:
          return "Overrides"
        case .requirementOf:
          return "Requirement of"
        case .optionalRequirementOf:
          return "Optional requirement of"
        }
      }
    }

    public let kind: Kind
    public let sourceMangledName: String
    public let targetMangledName: String

    enum CodingKeys: String, CodingKey {
      case kind
      case sourceMangledName = "source"
      case targetMangledName = "target"
    }
  }
}

// TODO: There's a lot of additional information available in the JSON format
// isn't represented here.
public struct SymbolGraph: Decodable {
  public let metadata: Metadata
  public let module: Module
  public let symbols: [Symbol]
  public let relationships: [Edge]
}

/// Metadata and Module info structures
extension SymbolGraph {
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
}

extension SymbolGraph {
  public struct Symbol: Decodable {
    public let kind: Kind
    public let identifier: Identifier
    public let pathComponents: [String]
    public let docComment: DocComment?
    public let names: Names
  }
}

extension SymbolGraph.Symbol {
  public enum Kind: String, Decodable, CustomStringConvertible {
    case `class` = "swift.class"
    case `struct` = "swift.struct"
    case `enum` = "swift.enum"
    case enumCase = "swift.enum.case"
    case `protocol` = "swift.protocol"
    case initializer = "swift.init"
    case deinitializer = "swift.deinit"
    case `operator` = "swift.func.op"
    case typeMethod = "swift.type.method"
    case instanceMethod = "swift.method"
    case function = "swift.func"
    case typeProperty = "swift.type.property"
    case instanceProperty = "swift.property"
    case variable = "swift.var"
    case typeSubscript = "swift.type.subscript"
    case `subscript` = "swift.subscript"
    case `associatedtype` = "swift.associatedtype"
    case `typealias` = "swift.typealias"

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
      case .deinitializer:
        return "Deinitializer"
      case .operator:
        return "Operator"
      case .typeMethod:
        return "Type Method"
      case .instanceMethod:
        return "Method"
      case .typeProperty:
        return "Type Property"
      case .instanceProperty:
        return "Property"
      case .typeSubscript:
        return "Type Subscript"
      case .subscript:
        return "Subscript"
      case .associatedtype:
        return "Associated Type"
      }
    }

    enum CodingKeys: String, CodingKey {
      case identifier
    }

    public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      guard let value = Kind(rawValue: try values.decode(String.self, forKey: .identifier)) else {
        throw DecodingError.typeMismatch(Kind.self, DecodingError.Context(codingPath: values.codingPath + [CodingKeys.identifier], debugDescription: ""))
      }
      self = value
    }
  }
}

extension SymbolGraph.Symbol {
  public struct Identifier: Decodable, Hashable {
    public let usr: String
    public let interfaceLanguage: String

    enum CodingKeys: String, CodingKey {
      case usr = "precise"
      case interfaceLanguage
    }
  }
}

extension SymbolGraph.Symbol {
  public struct DocComment: Decodable {
    public let lines: [Line]

    public struct Line: Decodable {
      public let range: Range?
      public let text: String

      public struct Range: Decodable {
        public let start: Position
        public let end: Position

        public struct Position: Decodable {
          public let line: Int
          public let character: Int
        }
      }
    }
  }
}

extension SymbolGraph.Symbol {
  public struct Names: Decodable {
    public struct Fragment: Decodable {
      public enum Kind: String, Decodable {
        case keyword, attribute, number, string, identifier, typeIdentifier,
             genericParameter, internalParam, externalParam, text
      }

      let kind: Kind
      let spelling: String
    }

    enum CodingKeys: String, CodingKey {
      case title, navigator, subHeading
    }

    public let title: String
    public let subHeading: [Fragment]
    public let navigator: [Fragment]
  }
}

extension SymbolGraph {
  public struct Edge: Decodable {
    public let kind: Kind
    public let source: String
    public let target: String
  }
}

extension SymbolGraph.Edge {
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
}

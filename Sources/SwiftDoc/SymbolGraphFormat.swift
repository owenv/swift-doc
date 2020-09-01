/// A graph of related symbols extracted from a Swift module.
public struct SymbolGraph: Decodable {
  /// Symbol graph format information.
  public let metadata: Metadata

  /// Description of the source module.
  public let module: Module

  public let symbols: [Symbol]
  public let relationships: [Edge]
}

public struct Version: Decodable {
  public let major: Int
  public let minor: Int?
  public let patch: Int?
  public let prerelease: Int?
}

/// Metadata and Module info structures
extension SymbolGraph {
  public struct Metadata: Decodable {
    public let formatVersion: Version
    /// Describes the Swift compiler used to generate the symbol graph.
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
  /// Represents a single symbol in a module.
  public struct Symbol: Decodable {
    /// The kind of symbol this is.
    public let kind: Kind
    /// The symbol's identifier.
    public let identifier: Identifier
    public let pathComponents: [String]
    /// A documentation comment attached to the symbol.
    public let docComment: DocComment?
    /// Names which can be used to identify the symbol in different contexts.
    public let names: Names
    /// Describes the parameters and return type, if applicable.
    public let functionSignature: FunctionSignature?
    /// Information about generic parameters and constraints, if applicable.
    public let swiftGenerics: GenericsInfo?
    /// Extended type information, if applicable.
    public let swiftExtension: ExtensionInfo?
    /// Breaks down parts of the declaration by type, for display/highlighting purposes.
    public let declarationFragments: [DeclarationFragment]
    /// Access level of the symbol.
    public let accessLevel: AccessLevel
    /// Platform/Language availability info, if applicable.
    public let availability: [Availability]?
    /// Source code location information, if available.
    public let location: Location?
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

public struct Position: Decodable {
  public let line: Int
  public let character: Int
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
      }
    }
  }
}

public struct DeclarationFragment: Decodable {
  public enum Kind: String, Decodable {
    case keyword, attribute, number, string, identifier, typeIdentifier,
         genericParameter, internalParam, externalParam, text
  }

  let kind: Kind
  let spelling: String
}


extension SymbolGraph.Symbol {
  public struct Names: Decodable {
    enum CodingKeys: String, CodingKey {
      case title, navigator, subHeading
    }

    public let title: String
    public let subHeading: [DeclarationFragment]
    public let navigator: [DeclarationFragment]
  }
}

extension SymbolGraph.Symbol {
  public struct FunctionSignature: Decodable {
    public let parameters: [Parameter]?
    public let returns: [DeclarationFragment]

    public struct Parameter: Decodable {
      public let name: String
      public let internalName: String?
      public let declarationFragments: [DeclarationFragment]
    }
  }
}

extension SymbolGraph.Symbol {
  public struct GenericsInfo: Decodable {
    public let parameters: [GenericParameter]?
    public let constraints: [GenericRequirement]?

    public struct GenericParameter: Decodable {
      public let name: String
      public let index: Int
      public let depth: Int
    }

    public struct GenericRequirement: Decodable {
      public let kind: Kind
      public let lhs: String
      public let rhs: String

      public enum Kind: String, Decodable {
        case conformance, superclass, sameType
      }
    }
  }
}

extension SymbolGraph.Symbol {
  public struct ExtensionInfo: Decodable {
    public let extendedModule: String
    public let constraints: [GenericsInfo.GenericRequirement]?
  }
}

extension SymbolGraph.Symbol {
  public enum AccessLevel: String, Decodable {
    case `private`, `fileprivate`, `internal`, `public`, `open`
  }
}

extension SymbolGraph.Symbol {
  public struct Availability: Decodable {
    public let domain: Domain

    public let message: String?
    public let renamed: String?

    public let introduced: Version?
    public let obseleted: Version?
    public let deprecated: Version?

    public let isUnconditionallyDeprecated: Bool?
    public let isUnconditionallyUnavailable: Bool?

    public enum Domain: String, Decodable {
      case spm = "SwiftPM"
      case swift = "Swift"

      case ios = "iOS"
      case macCatalyst, macOS, tvOS, watchOS
      case iosAppExtension = "iOSAppExtension"
      case macCatalystAppExtension, macOSAppExtension, tvOSAppExtension, watchOSAppExtension

      case platformAgnostic = "*"
    }
  }
}

extension SymbolGraph.Symbol {
  public struct Location: Decodable {
    public let uri: String
    public let position: Position
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

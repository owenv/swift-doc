let testSymbolGraphData = """
{
"metadata": {
  "formatVersion": {
    "major": 0,
    "minor": 1,
    "patch": 0
  },
  "generator": "Apple Swift version 5.2-dev"
},
"module": {
  "name": "Swift",
  "platform": {
    "architecture": "x86_64",
    "vendor": "apple",
    "operatingSystem": {
      "name": "darwin",
      "minimumVersion": {
        "major": 19,
        "minor": 3,
        "patch": 0
      }
    }
  }
},
"symbols": [
{
  "kind": {
    "identifier": "swift.function",
    "displayName": "Function"
  },
  "identifier": {
    "precise": "s:s7UnicodeO5UTF16O7isASCIIySbs6UInt16VFZ",
    "simpleComponents": [
      "Unicode",
      "UTF16",
      "isASCII(_:)"
    ]
  },
  "names": {
    "title": "isASCII(_:)",
    "subheading": [
      {
        "kind": "keyword",
        "spelling": "static"
      },
      {
        "kind": "text",
        "spelling": " "
      },
      {
        "kind": "keyword",
        "spelling": "func"
      },
      {
        "kind": "text",
        "spelling": " "
      },
      {
        "kind": "identifier",
        "spelling": "isASCII"
      },
      {
        "kind": "text",
        "spelling": "("
      },
      {
        "kind": "typeIdentifier",
        "spelling": "Unicode",
        "preciseIdentifier": "s:s7UnicodeO"
      },
      {
        "kind": "text",
        "spelling": "."
      },
      {
        "kind": "typeIdentifier",
        "spelling": "UTF16",
        "preciseIdentifier": "s:s7UnicodeO5UTF16O"
      },
      {
        "kind": "text",
        "spelling": "."
      },
      {
        "kind": "typeIdentifier",
        "spelling": "CodeUnit",
        "preciseIdentifier": "s:s7UnicodeO5UTF16O8CodeUnita"
      },
      {
        "kind": "text",
        "spelling": ") -> "
      },
      {
        "kind": "typeIdentifier",
        "spelling": "Bool",
        "preciseIdentifier": "s:Sb"
      }
    ]
  },
  "docComment": {
    "lines": [
      {
        "text": "Returns whether the given code unit represents an ASCII scalar"
      }
    ]
  },
  "functionSignature": {
    "parameters": [
      {
        "name": "x",
        "declarationFragments": [
          {
            "kind": "identifier",
            "spelling": "x"
          },
          {
            "kind": "text",
            "spelling": ": "
          },
          {
            "kind": "typeIdentifier",
            "spelling": "Unicode",
            "preciseIdentifier": "s:s7UnicodeO"
          },
          {
            "kind": "text",
            "spelling": "."
          },
          {
            "kind": "typeIdentifier",
            "spelling": "UTF16",
            "preciseIdentifier": "s:s7UnicodeO5UTF16O"
          },
          {
            "kind": "text",
            "spelling": "."
          },
          {
            "kind": "typeIdentifier",
            "spelling": "CodeUnit",
            "preciseIdentifier": "s:s7UnicodeO5UTF16O8CodeUnita"
          }
        ]
      }
    ],
    "returns": [
      {
        "kind": "typeIdentifier",
        "spelling": "Bool",
        "preciseIdentifier": "s:Sb"
      }
    ]
  },
  "declarationFragments": [
    {
      "kind": "keyword",
      "spelling": "static"
    },
    {
      "kind": "text",
      "spelling": " "
    },
    {
      "kind": "keyword",
      "spelling": "func"
    },
    {
      "kind": "text",
      "spelling": " "
    },
    {
      "kind": "identifier",
      "spelling": "isASCII"
    },
    {
      "kind": "text",
      "spelling": "("
    },
    {
      "kind": "identifier",
      "spelling": "_"
    },
    {
      "kind": "text",
      "spelling": ": "
    },
    {
      "kind": "typeIdentifier",
      "spelling": "Unicode",
      "preciseIdentifier": "s:s7UnicodeO"
    },
    {
      "kind": "text",
      "spelling": "."
    },
    {
      "kind": "typeIdentifier",
      "spelling": "UTF16",
      "preciseIdentifier": "s:s7UnicodeO5UTF16O"
    },
    {
      "kind": "text",
      "spelling": "."
    },
    {
      "kind": "typeIdentifier",
      "spelling": "CodeUnit",
      "preciseIdentifier": "s:s7UnicodeO5UTF16O8CodeUnita"
    },
    {
      "kind": "text",
      "spelling": ") -> "
    },
    {
      "kind": "typeIdentifier",
      "spelling": "Bool",
      "preciseIdentifier": "s:Sb"
    }
  ],
  "accessLevel": "public"
}
],
"relationships": [
{
  "kind": "memberOf",
  "source": "s:s7UnicodeO5UTF16O7isASCIIySbs6UInt16VFZ",
  "target": "s:Ss9UTF16ViewV"
},
{
  "kind": "conformsTo",
  "source": "s:s7UnicodeO5UTF16O7isASCIIySbs6UInt16VFZ",
  "target": "s:SS9UTF16ViewV"
}
]
}
""".data(using: .utf8)!

import XCTest
@testable import StringsTranslator

struct TranslatorForTest: Translator {
  func translate(_ string: String) -> String {
    if string == "Apple" {
      return "りんご"
    }
    if string == "Orange" {
      return "みかん"
    }
    fatalError()
  }
}

class StringsTranslatorTests: XCTestCase {
  func test() throws {
    let translator = StringsTranslator(translator: TranslatorForTest())
    let list = StringsList(
      manuals: [
        .init(key: "apple", value: "Apple"),
      ],
      automatics: [
        .init(key: "orange", value: "Orange"),
      ]
    )
    
    let result = try translator.translate(list: list)
    
    XCTAssertEqual(
      result,
      StringsList(
        manuals: [],
        automatics: [
          .init(key: "apple", value: "りんご"),
          .init(key: "orange", value: "みかん")
        ]
      )
    )
  }
}

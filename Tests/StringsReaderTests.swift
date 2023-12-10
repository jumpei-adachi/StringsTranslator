import XCTest
@testable import StringsTranslator

class StringsTests: XCTestCase {
  func testRead() throws {
    let list = try StringsReader.read(string: """
"apple" = "りんご";
"orange" = "みかん";
""")
    XCTAssertEqual(
      list,
      .init(
        manuals: [],
        automatics: [
          .init(key: "apple", value: "りんご"),
          .init(key: "orange", value: "みかん"),
        ]
      )
    )
  }
  
  func testManual() throws {
    let list = try StringsReader.read(string: """
"apple" = "りんご";
"orange" = "みかん";

/* manual */
"grape" = "ぶどう";
"peach" = "もも";
""")
    XCTAssertEqual(
      list,
      .init(
        manuals: [
          .init(key: "grape", value: "ぶどう"),
          .init(key: "peach", value: "もも"),
        ],
        automatics: [
          .init(key: "apple", value: "りんご"),
          .init(key: "orange", value: "みかん"),
        ]
      )
    )
  }
  
  func testRepeatedlySwitchMode() throws {
    let list = try StringsReader.read(string: """
"apple" = "りんご";
"orange" = "みかん";

/* manual */
"grape" = "ぶどう";
"peach" = "もも";

/* automatic */
"strawberry" = "いちご";
"blueberry" = "ブルーベリー";

/* manual */
"watermelon" = "すいか";
"melon" = "メロン";
""")
    XCTAssertEqual(
      list,
      .init(
        manuals: [
          .init(key: "grape", value: "ぶどう"),
          .init(key: "peach", value: "もも"),
          .init(key: "watermelon", value: "すいか"),
          .init(key: "melon", value: "メロン")
        ],
        automatics: [
          .init(key: "apple", value: "りんご"),
          .init(key: "orange", value: "みかん"),
          .init(key: "strawberry", value: "いちご"),
          .init(key: "blueberry", value: "ブルーベリー"),
        ]
      )
    )
  }
}

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
  
  func testContext() throws {
    let list = try StringsReader.read(string: """
/* manual */
/* context: foo */
"apple" = "りんご";
"orange" = "みかん";

/* context: bar */
"grape" = "ぶどう";
"peach" = "もも";

/* context: nil */
"strawberry" = "いちご";
"blueberry" = "ブルーベリー";

/* automatic */
"watermelon" = "スイカ";

/* context: baz */
"melon" = "メロン";

/* manual */
"banana" = "バナナ";
""")
    
    XCTAssertEqual(
      list,
      .init(
        manuals: [
          .init(key: "apple", value: "りんご", context: "foo"),
          .init(key: "orange", value: "みかん", context: "foo"),
          .init(key: "grape", value: "ぶどう", context: "bar"),
          .init(key: "peach", value: "もも", context: "bar"),
          .init(key: "strawberry", value: "いちご", context: nil),
          .init(key: "blueberry", value: "ブルーベリー", context: nil),
          .init(key: "banana", value: "バナナ", context: nil),
        ],
        automatics: [
          .init(key: "watermelon", value: "スイカ", context: nil),
          .init(key: "melon", value: "メロン", context: "baz"),
        ]
      )
    )
  }
  
  func testQuotes() throws {
    let list = try StringsReader.read(string: """
"foo" = "bar\"\"baz";
""")
    XCTAssertEqual(list, .init(manuals: [], automatics: [.init(key: "foo", value: "bar\"\"baz")]))
  }
}

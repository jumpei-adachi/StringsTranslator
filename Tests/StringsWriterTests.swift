import XCTest
@testable import StringsTranslator

class StringsWriterTests: XCTestCase {
  func testWriteIncludingOnlyAutomatic() {
    let list = StringsList(
      manuals: [
      ],
      automatics: [
        .init(key: "apple", value: "りんご"),
        .init(key: "orange", value: "みかん"),
      ]
    )
    
    let string = StringsWriter.write(list: list)
    
    XCTAssertEqual(string, """
"apple" = "りんご";
"orange" = "みかん";

""")
  }
  
  func testWriteIncludingBothManualAndAutomatic() {
    let list = StringsList(
      manuals: [
        .init(key: "grape", value: "ぶどう"),
        .init(key: "peach", value: "もも"),
      ],
      automatics: [
        .init(key: "apple", value: "りんご"),
        .init(key: "orange", value: "みかん"),
      ]
    )
    
    let string = StringsWriter.write(list: list)
    
    XCTAssertEqual(string, """
/* manual */
"grape" = "ぶどう";
"peach" = "もも";

/* automatic */
"apple" = "りんご";
"orange" = "みかん";

""")
  }
  
  func testWriteIncludingOnlyManual() {
    let list = StringsList(
      manuals: [
        .init(key: "grape", value: "ぶどう"),
        .init(key: "peach", value: "もも"),
      ],
      automatics: [
      ]
    )
    
    let string = StringsWriter.write(list: list)
    
    XCTAssertEqual(string, """
/* manual */
"grape" = "ぶどう";
"peach" = "もも";

""")
  }
  
  func testContext() {
    let list = StringsList(
      manuals: [
        .init(key: "apple", value: "りんご", context: nil),
        .init(key: "blueberry", value: "ブルーベリー", context: "foo"),
        .init(key: "strawberry", value: "いちご", context: "foo"),
        .init(key: "melon", value: "メロン", context: "bar"),
        .init(key: "banana", value: "バナナ", context: nil),
        .init(key: "watermelon", value: "スイカ", context: "bar"),
      ],
      automatics: [
        .init(key: "peach", value: "モモ", context: "bar"),
      ]
    )
    
    let string = StringsWriter.write(list: list)
    XCTAssertEqual(
      string,
      """
/* manual */
"apple" = "りんご";

/* context: foo */
"blueberry" = "ブルーベリー";
"strawberry" = "いちご";

/* context: bar */
"melon" = "メロン";

/* context: nil */
"banana" = "バナナ";

/* context: bar */
"watermelon" = "スイカ";

/* automatic */

/* context: bar */
"peach" = "モモ";

"""
    )
  }
}

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
}

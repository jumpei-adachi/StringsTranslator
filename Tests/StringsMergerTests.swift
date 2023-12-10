import XCTest
@testable import StringsTranslator

class StringsMergerTests: XCTestCase {
  func test() {
    let result = StringsMerger.merge(
      from: StringsList(
        manuals: [],
        automatics: [
          .init(key: "orange", value: "みかん"), // into側にorangeがあるので削除される
          .init(key: "grape", value: "ぶどう"),
        ]
      ),
      into: StringsList(
        manuals: [
          .init(key: "orange", value: "ミカン"),
          .init(key: "peach", value: "モモ"),
        ],
        // into側のautomaticsは全て削除される
        automatics: [
          .init(key: "strawberry", value: "イチゴ"),
        ]
      )
    )
    
    XCTAssertEqual(
      result,
      .init(
        manuals: [
          .init(key: "orange", value: "ミカン"),
          .init(key: "peach", value: "モモ"),
        ],
        automatics: [
          .init(key: "grape", value: "ぶどう"),
        ]
      )
    )
  }
}

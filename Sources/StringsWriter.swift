import Foundation

class StringsWriter {
  static func write(list: StringsList, to url: URL) throws {
    let string = write(list: list)
    try string.write(to: url, atomically: true, encoding: .utf8)
  }
  
  static func write(list: StringsList) -> String {
    var result = ""
    if !list.manuals.isEmpty {
      result += "/* manual */\n"
      for record in list.manuals {
        result += toString(record: record) + "\n"
      }
      
      if !list.automatics.isEmpty {
        result += "\n"
        result += "/* automatic */\n"
      }
    }
    for record in list.automatics {
      result += toString(record: record) + "\n"
    }
    return result
  }
  
  private static func toString(record: StringsRecord) -> String {
    return #""\#(record.key)" = "\#(escape(record.value))";"#
  }
  
  private static func escape(_ string: String) -> String {
    return string.replacingOccurrences(of: "\"", with: "\\\"")
  }
}

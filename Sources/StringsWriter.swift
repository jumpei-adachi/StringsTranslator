import Foundation

class StringsWriter {
  static func write(list: StringsList, to url: URL) throws {
    let string = write(list: list)
    try string.write(to: url, atomically: true, encoding: .utf8)
  }
  
  static func write(list: StringsList) -> String {
    var result = ""
    
    // manualsを出力
    if !list.manuals.isEmpty {
      do {
        var context: String? = nil
        result += "/* manual */\n"
        for record in list.manuals {
          if record.context != context {
            result += "\n\(toString(context: record.context))\n"
            context = record.context
          }
          result += toString(record: record) + "\n"
        }
      }
      
      if !list.automatics.isEmpty {
        result += "\n"
        result += "/* automatic */\n"
      }
    }
    
    // automaticsを出力
    do {
      var context: String? = nil
      for record in list.automatics {
        if record.context != context {
          result += "\n\(toString(context: record.context))\n"
          context = record.context
        }
        result += toString(record: record) + "\n"
      }
    }
    return result
  }
  
  private static func toString(context: String?) -> String {
    return "/* context: \(context ?? "nil") */"
  }
  
  private static func toString(record: StringsRecord) -> String {
    return #""\#(record.key)" = "\#(escape(record.value))";"#
  }
  
  private static func escape(_ string: String) -> String {
    return string.replacingOccurrences(of: "\"", with: "\\\"")
  }
}

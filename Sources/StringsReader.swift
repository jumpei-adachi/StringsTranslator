import Foundation

class StringsReader {
  static func read(url: URL) throws -> StringsList {
    return try read(string: try String(contentsOf: url))
  }
  
  static func read(string: String) throws -> StringsList {
    var manuals: [StringsRecord] = []
    var automatics: [StringsRecord] = []
    
    enum Mode {
      case manual
      case automatic
    }
    
    var context: String? = nil
    var mode: Mode = .automatic
    for line in string.split(separator: "\n") {
      if line.starts(with: "/* manual */") {
        mode = .manual
        context = nil
        continue
      }
      if line.starts(with: "/* automatic */") {
        mode = .automatic
        context = nil
        continue
      }
      if line.starts(with: "/* context: nil */") {
        context = nil
        continue
      }
      if let match = try! #/\/\* context: (.*) \*\//#.wholeMatch(in: line) {
        context = String(match.output.1)
        continue
      }
      if case let (_, key, value)? = try #/^"(.*)"\s*=\s*"(.*)";$/#.wholeMatch(in: line)?.output {
        let record = StringsRecord(key: String(key), value: String(value), context: context)
        switch mode {
        case .manual:
          manuals.append(record)
        case .automatic:
          automatics.append(record)
        }
      }
    }
    return StringsList(manuals: manuals, automatics: automatics)
  }
}

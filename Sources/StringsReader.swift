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
    
    var mode: Mode = .automatic
    for line in string.split(separator: "\n") {
      if line.starts(with: "/* manual */") {
        mode = .manual
        continue
      }
      if line.starts(with: "/* automatic */") {
        mode = .automatic
        continue
      }
      if case let (_, key, value)? = try #/^"(.*)"\s*=\s*"(.*)";$/#.wholeMatch(in: line)?.output {
        let record = StringsRecord(key: String(key), value: String(value))
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

struct StringsTranslator {
  let translator: (StringsRecord) -> any Translator
  
  init(translator: @escaping (StringsRecord) -> any Translator) {
    self.translator = translator
  }
  
  func translate(list: StringsList) throws -> StringsList {
    return try StringsList(
      manuals: [],
      automatics: list.records.map { record in
        StringsRecord(key: record.key, value: try translator(record).translate(record.value))
      }
    )
  }
}

protocol Translator {
  func translate(_ string: String) throws -> String
}

struct LanguageForAPI: RawRepresentable {
  typealias RawValue = String
  
  let rawValue: String
  
  init(rawValue: String) {
    self.rawValue = rawValue
  }
}

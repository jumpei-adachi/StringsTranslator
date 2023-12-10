struct TranslationTask: Decodable {
  let translationMethod: TranslationMethod
  
  /// 翻訳元となる言語の、Xcodeの.lprojフォルダに使われている言語名
  let sourceLanguage: String
  
  /// 翻訳先となる言語の、Xcodeで.lprojフォルダに使われている言語名
  let destinationLanguage: String
  
  /// 翻訳元となる言語の、翻訳APIで使われている言語名
  let internalSourceLanguage: String
  
  /// 翻訳先となる言語の、翻訳APIで使われている言語名
  let internalDestinationLanguage: String
  
  init(using translationMethod: TranslationMethod, from sourceLanguage: String, into destinationLanguage: String, internalFrom internalSourceLanguage: String, internalInto internalDestinationLanguage: String) {
    self.translationMethod = translationMethod
    self.sourceLanguage = sourceLanguage
    self.destinationLanguage = destinationLanguage
    self.internalSourceLanguage = internalSourceLanguage
    self.internalDestinationLanguage = internalDestinationLanguage
  }
  
  enum CodingKeys: CodingKey {
    case method
    case from
    case into
    case internalFrom
    case internalInto
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.translationMethod = try container.decode(TranslationMethod.self, forKey: .method)
    self.sourceLanguage = try container.decode(String.self, forKey: .from)
    self.destinationLanguage = try container.decode(String.self, forKey: .into)
    self.internalSourceLanguage = try container.decode(String.self, forKey: .internalFrom)
    self.internalDestinationLanguage = try container.decode(String.self, forKey: .internalInto)
  }
}

enum TranslationMethod: String, Decodable {
  case deepL = "deepL"
  case google = "google"
  case deepLChinese = "deepL-chinese"
}

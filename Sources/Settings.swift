struct Settings: Decodable {
  /// .lprojが置かれているフォルダのパス
  let path: String
  
  /// APIキーが書かれているJSONファイルのパス
  let apiKeyPath: String
  
  /// deepLの翻訳結果のキャッシュファイルのパス
  let deepLCachePath: String
  
  /// Google翻訳の翻訳結果のキャッシュファイルのパス
  let googleCachePath: String
  
  /// 翻訳対象となる.stringsファイルのリスト
  let targets: [String]
  
  /// 翻訳タスクのリスト
  let tasks: [TranslationTask]
}

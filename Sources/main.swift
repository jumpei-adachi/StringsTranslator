import Foundation
import Translator

func main() {
  if CommandLine.arguments.count != 2 {
    print("USAGE: StringsTranslator <settings-path>")
    return
  }
  
  let baseURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
  
  let settings: Settings = readSettings(baseURL)
  
  let apiKey: APIKey = readAPIKey(baseURL: baseURL, settings: settings)
  
  translate(baseURL: baseURL, settings: settings, apiKey: apiKey)
}

main()

func readSettings(_ baseURL: URL) -> Settings {
  do {
    let settingsURL = baseURL.appending(component: CommandLine.arguments[1])
    let decoder = JSONDecoder()
    return try decoder.decode(Settings.self, from: try Data(contentsOf: settingsURL))
  } catch {
    print("""
    Settings file format is as follows:
    {
      "path": "MyProject/Localization",
      "apiKeyPath": "settings/apikey.json",
      "deepLCachePath": "caches/deepl.sqlite3",
      "googleCachePath": "caches/google.sqlite3",
      "targets": [
        "Localizable.strings"
      ],
      "tasks": [
        {
          "method": "deepL",
          "from": "en",
          "into": "bg",
          "internalFrom": "en",
          "internalInto": "bg"
        },
        {
          "method": "google",
          "from": "en",
          "into": "ca",
          "internalFrom": "en",
          "internalInto": "ca"
        }
      ]
    }
    """)
    fatalError(error.localizedDescription)
  }
}

func readAPIKey(baseURL: URL, settings: Settings) -> APIKey {
  do {
    let apiKeyURL = baseURL.appending(component: settings.apiKeyPath)
    let decoder = JSONDecoder()
    return try decoder.decode(APIKey.self, from: try Data(contentsOf: apiKeyURL))
  } catch {
    print("""
    API key file format is as follows:
    {
      "deepL": "xxxxxxxx",
      "google": "xxxxxxxx"
    }
    """)
    fatalError(error.localizedDescription)
  }
}

func translate(baseURL: URL, settings: Settings, apiKey: APIKey) {
  do {
    let localizationURL = baseURL.appending(component: settings.path)
    for task in settings.tasks {
      print("Translating \(task.sourceLanguage) into \(task.destinationLanguage)...")
      let translator: any TextTranslator
      switch task.translationMethod {
      case .deepL:
        var deepL = DeepLTextTranslator(apiKey: apiKey.deepL)
        translator = CachedTextTranslator(
          translator: deepL,
          cacheURL: baseURL.appending(component: settings.deepLCachePath)
        )
      case .google:
        translator = CachedTextTranslator(
          translator: GoogleTextTranslator(apiKey: apiKey.google),
          cacheURL: baseURL.appending(component: settings.googleCachePath)
        )
      case .deepLChinese:
        translator = ChineseTextTranslator(
          translator: CachedTextTranslator(
            translator: DeepLTextTranslator(apiKey: apiKey.deepL),
            cacheURL: baseURL.appending(component: settings.deepLCachePath)
          )
        )
      }
      let sourceDirectoryURL = localizationURL.appending(component: "\(task.sourceLanguage).lproj")
      for target in settings.targets {
        let sourceURL = sourceDirectoryURL.appending(component: target)
        
        let list = try StringsReader.read(url: sourceURL)
        
        var result = try StringsTranslator(
          translator: TranslatorWrapper(
            source: task.internalSourceLanguage,
            target: task.internalDestinationLanguage,
            translator: translator
          )
        ).translate(list: list)
        
        let destinationDirectoryURL = localizationURL.appending(component: "\(task.destinationLanguage).lproj")
        if !FileManager.default.fileExists(atPath: destinationDirectoryURL.path()) {
          try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: false)
        }
        let destinationURL = destinationDirectoryURL.appending(component: "\(sourceURL.lastPathComponent)")
        
        if FileManager.default.fileExists(atPath: destinationURL.path(percentEncoded: false)) {
          let targetList = try StringsReader.read(url: destinationURL)
          
          result = StringsMerger.merge(from: result, into: targetList)
        }
        
        try StringsWriter.write(list: result, to: destinationURL)
      }
    }
  } catch let error as TranslationError {
    switch error {
    case .badStatusCode(let code): print("bad status code: \(code)")
    case .invalidHTTPResponse: print("invalid http response")
    case .unexpectedManyTranslations: print("unexpected many translations")
    case .unsupportedLanguagePair: print("unsupported language pair")
    case .unsupportedResponse: print("unsupported response")
    }
  } catch {
    fatalError(error.localizedDescription)
  }
}

struct TranslatorWrapper: Translator {
  let source: String
  let target: String
  let translator: any TextTranslator
  
  func translate(_ string: String) throws -> String {
    try translator.translate(text: string, from: source, to: target)
  }
}

// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "StringsTranslator",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/jumpei-adachi/Translator.git", branch: "main")
  ],
  targets: [
    .executableTarget(
      name: "StringsTranslator",
      dependencies: ["Translator"]
    ),
    .testTarget(
      name: "StringsTranslatorTests",
      dependencies: ["StringsTranslator"]
    )
  ]
)

class StringsMerger {
  static func merge(from source: StringsList, into target: StringsList) -> StringsList {
    return StringsList(
      manuals: target.manuals,
      automatics: source.automatics.filter { record in
        !target.manuals.contains { $0.key == record.key }
      }
    )
  }
}

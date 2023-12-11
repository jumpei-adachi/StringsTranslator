class StringsMerger {
  static func merge(from source: StringsList, into target: StringsList) -> StringsList {
    return StringsList(
      manuals: target.manuals,
      automatics: source.manuals.filter { record in
        !target.manuals.contains { $0.key == record.key }
      } + source.automatics.filter { record in
        !source.manuals.contains { $0.key == record.key } &&
        !target.manuals.contains { $0.key == record.key }
      }
    )
  }
}

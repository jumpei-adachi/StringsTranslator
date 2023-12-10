struct StringsList: Equatable {
  let manuals: [StringsRecord]
  let automatics: [StringsRecord]
  
  var records: [StringsRecord] {
    return manuals + automatics
  }
}

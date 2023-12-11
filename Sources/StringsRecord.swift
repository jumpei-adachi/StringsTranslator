struct StringsRecord: Equatable {
  let key: String
  let value: String
  let context: String?
  
  init(key: String, value: String, context: String? = nil) {
    self.key = key
    self.value = value
    self.context = context
  }
}

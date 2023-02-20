import Foundation

struct SpaceXFairingsJSON: BatchInsertable {
  var reused: Bool?
  var recoveryAttempt: Bool?
  var recovered: Bool?
  var ships: [String]
  var id = UUID()

  private enum CodingKeys: String, CodingKey {
    case reused
    case recoveryAttempt = "recovery_attempt"
    case recovered
    case ships
  }

  var dictionaryValue: [String: Any] {
    [
      "reused": reused as Any,
      "recoveryAttempt": recoveryAttempt as Any,
      "recovered": recovered as Any,
      "ships": ships,
      "id": id
    ]
  }
}

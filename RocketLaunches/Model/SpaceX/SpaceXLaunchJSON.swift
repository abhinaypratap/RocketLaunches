import Foundation

struct SpaceXLaunchJSON: BatchInsertable {
  var fairings: SpaceXFairingsJSON?
  var links: SpaceXLinksJSON
  var staticFireDateUTC: String?
  var staticFireDateUnix: Int?
  var tdb: Bool?
  var net: Bool
  var window: Int?
  var rocket: String
  var success: Bool?
  var failures: [SpaceXFailureJSON]
  var details: String?
  var crew: [[String: String]]
  var ships: [String]
  var capsules: [String]
  var payloads: [String]
  var launchpad: String?
  var autoUpdate: Bool
  var flightNumber: Int
  var name: String
  var dateUtc: String
  var dateUnix: Int
  var dateLocal: String
  var datePrecision: String
  var upcoming: Bool
  var cores: [SpaceXLaunchCoreJSON]
  var id: String

  private enum CodingKeys: String, CodingKey {
    case fairings
    case links
    case staticFireDateUTC = "static_fire_date_utc"
    case staticFireDateUnix = "static_fire_date_unix"
    case tdb
    case net
    case window
    case rocket
    case success
    case failures
    case details
    case crew
    case ships
    case capsules
    case payloads
    case launchpad
    case autoUpdate = "auto_update"
    case flightNumber = "flight_number"
    case name
    case dateUtc = "date_utc"
    case dateUnix = "date_unix"
    case dateLocal = "date_local"
    case datePrecision = "date_precision"
    case upcoming
    case cores
    case id
  }

  var dictionaryValue: [String: Any] {
    [
      "fairings": fairings as Any,
      "links": links,
      "staticFireDateUTC": staticFireDateUTC as Any,
      "staticFireDateUnix": staticFireDateUnix as Any,
      "tdb": tdb as Any,
      "net": net,
      "window": window as Any,
      "rocket": rocket,
      "success": success as Any,
      "failures": failures,
      "details": details as Any,
      "crew": crew,
      "ships": ships,
      "capsules": capsules,
      "payloads": payloads,
      "launchpad": launchpad as Any,
      "autoUpdate": autoUpdate,
      "flightNumber": flightNumber,
      "name": name,
      "dateUtc": dateUtc,
      "dateUnix": dateUnix,
      "dateLocal": dateLocal,
      "datePrecision": datePrecision,
      "upcoming": upcoming,
      "cores": cores,
      "id": id
    ]
  }
}

struct SpaceXFailureJSON: BatchInsertable {
  var time: Double?
  var altitude: Double?
  var reason: String?

  var dictionaryValue: [String: Any] {
    [
      "time": time as Any,
      "altitude": altitude as Any,
      "reason": reason as Any
    ]
  }
}

struct SpaceXLaunchCoreJSON: BatchInsertable {
  var core: String?
  var flight: Int?
  var gridfins: Bool?
  var legs: Bool?
  var reused: Bool?
  var landingAttempt: Bool?
  var landingSuccess: Bool?
  var landingType: String?
  var landpad: String?

  private enum CodingKeys: String, CodingKey {
    case core
    case flight
    case gridfins
    case legs
    case reused
    case landingAttempt = "landing_attempt"
    case landingSuccess = "landing_success"
    case landingType = "landing_type"
    case landpad
  }

  var dictionaryValue: [String: Any] {
    [
      "core": core as Any,
      "flight": flight as Any,
      "gridfins": gridfins as Any,
      "legs": legs as Any,
      "reused": reused as Any,
      "landingAttempt": landingAttempt as Any,
      "landingSuccess": landingSuccess as Any,
      "landingType": landingType as Any,
      "landpad": landpad as Any
    ]
  }
}

protocol BatchInsertable: Codable {
  var dictionaryValue: [String: Any] { get }
}

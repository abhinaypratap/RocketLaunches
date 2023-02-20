import Foundation

enum NetworkError: Error {
  case invalidCode
  case invalidURL
}

enum SpaceXAPI {
  static func getAllLaunches() async throws -> [SpaceXLaunchJSON] {
    do {
      let launches = try await loadJSON(from: "https://api.spacexdata.com/v5/launches", for: SpaceXLaunchJSON.self)
      return launches
    } catch {
      print("Error getting all launches: \(error)")
    }
    return []
  }

  static func getLatestLaunch() async throws -> [SpaceXLaunchJSON] {
    do {
      let launches = try await loadSingleJSON(from: "https://api.spacexdata.com/v5/launches/latest",
                                              for: SpaceXLaunchJSON.self)
      return [launches]
    } catch {
      print("Error getting latest launches: \(error)")
    }
    return []
  }

  static func getPastLaunches() async throws -> [SpaceXLaunchJSON] {
    do {
      let launches = try await loadJSON(from: "https://api.spacexdata.com/v5/launches/past", for: SpaceXLaunchJSON.self)
      return launches
    } catch {
      print("Error getting past launches: \(error)")
    }
    return []
  }

  static func getUpcomingLaunches() async throws -> [SpaceXLaunchJSON] {
    do {
      let launches = try await loadJSON(from: "https://api.spacexdata.com/v5/launches/upcoming",
                                        for: SpaceXLaunchJSON.self)
      return launches
    } catch {
      print("Error getting upcoming launches: \(error)")
    }
    return []
  }

  static func loadSingleJSON<T: Codable>(from urlString: String, for type: T.Type) async throws -> T {
    guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
    let request = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidCode
    }
    let jsonObjects: T = try JSONDecoder().decode(T.self, from: data)
    return jsonObjects
  }

  static func loadJSON<T: Codable>(from urlString: String, for type: T.Type) async throws -> [T] {
    guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
    let request = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidCode
    }
    let jsonObjects: [T] = try JSONDecoder().decode([T].self, from: data)
    return jsonObjects
  }
}

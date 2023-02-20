import Foundation

struct SpaceXLinksJSON: BatchInsertable {
  var patch: [String: String?]
  var reddit: [String: String?]
  var flickr: [String: [String]]
  var presskit: String?
  var webcast: String?
  var youtubeId: String?
  var article: String?
  var wikipedia: String?
  var id = UUID()

  private enum CodingKeys: String, CodingKey {
    case patch
    case reddit
    case flickr
    case presskit
    case webcast
    case youtubeId = "youtube_id"
    case article
    case wikipedia
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.wikipedia = try container.decode(Optional<String>.self, forKey: .wikipedia)
    self.article = try container.decode(Optional<String>.self, forKey: .article)
    self.youtubeId = try container.decode(Optional<String>.self, forKey: .youtubeId)
    self.webcast = try container.decode(Optional<String>.self, forKey: .webcast)
    self.presskit = try container.decode(Optional<String>.self, forKey: .presskit)
    self.flickr = try container.decode([String: [String]].self, forKey: .flickr)
    self.reddit = try container.decode([String: String?].self, forKey: .reddit)
    self.patch = try container.decode([String: String?].self, forKey: .patch)

    for (key, value) in reddit {
      // swiftlint:disable:next for_where
      if value == nil {
        reddit[key] = ""
      }
    }

    for (key, value) in patch {
      // swiftlint:disable:next for_where
      if value == nil {
        patch[key] = ""
      }
    }
  }

  var dictionaryValue: [String: Any] {
    [
      "patch": patch as Any,
      "reddit": reddit as Any,
      "flickr": flickr as Any,
      "presskit": presskit as Any,
      "webcast": webcast as Any,
      "youtubeid": youtubeId as Any,
      "article": article as Any,
      "wikipedia": wikipedia as Any,
      "id": id
    ]
  }
}

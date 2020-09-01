import Foundation


public enum MessagePayload: Codable {
  public struct Text: Codable {
    public let text: String
    public let trackingData: String?

    private enum CodingKeys: String, CodingKey {
      case text
      case trackingData = "tracking_data"
    }
  }

  case text(Text)

  public var kind: MessageKind {
    switch self {
    case .text:
      return .text
    }
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let singleValueContainer = try decoder.singleValueContainer()
    switch try container.decode(MessageKind.self, forKey: .kind) {
    case .text:
      self = .text(try singleValueContainer.decode(Text.self))
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    var keyedContainer = encoder.container(keyedBy: CodingKeys.self)
    try keyedContainer.encode(kind.rawValue, forKey: .kind)
    
    switch self {
    case .text(let text):
      try container.encode(text)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case kind = "type"
  }
}

import Foundation

public struct CallbackPayload: Decodable {
  public enum Event {
    case message(MessageEvent)
  }

  public let event: Event
  public let timestamp: Date
  public let messageToken: MessageToken

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let eventKindString = try container.decode(String.self, forKey: .event)
    switch eventKindString {
    case "message":
      let otherContainer = try decoder.singleValueContainer()
      let messageEvent = try otherContainer.decode(MessageEvent.self)
      self.event = .message(messageEvent)
    default:
      throw ViberDecodingError.unsupportedCallback(eventKindString)
    }

    self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    self.messageToken = try container.decode(MessageToken.self, forKey: .messageToken)
  }

  private enum CodingKeys: String, CodingKey {
    case event
    case timestamp
    case messageToken = "message_token"
  }
}

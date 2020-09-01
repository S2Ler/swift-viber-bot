import Foundation

public struct MessageEvent: Decodable {
  public let sender: MessageSender
  public let payload: MessagePayload
  public let isSilent: Bool

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.sender = try container.decode(MessageSender.self, forKey: .sender)
    self.isSilent = try container.decode(Bool.self, forKey: .isSilent)

    let messageContainer = try container.nestedContainer(keyedBy: MessageCodingKeys.self, forKey: .message)
    switch try messageContainer.decode(MessageKind.self, forKey: .type) {
    case .text:
      self.payload = .text(try container.decode(MessagePayload.Text.self, forKey: .message))
    }
  }

  private enum CodingKeys: String, CodingKey {
    case message
    case payment
    case sender
    case isSilent = "silent"
  }

  private enum MessageCodingKeys: String, CodingKey {
    case text
    case type
    case trackingData = "tracking_data"
  }
}

extension MessageEvent: CustomStringConvertible {
  public var description: String {
    switch payload {
    case .text(let textPayload):
      return textPayload.text
    }
  }
}

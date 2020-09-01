import Foundation
import Networker
import ViberBotDataModels
import Combine

public extension RequestPath {
  static var sendMessage: RequestPath { "/send_message" }
}

public struct SendMessageParams: Encodable {
  public enum Payload {
    case message(MessagePayload)
    case payment(PaymentPayload)
  }

  public let receiver: ViberUserId
  public let minApiVersion: Int
  public let payload: Payload

  public init(receiver: ViberUserId, minApiVersion: Int, payload: SendMessageParams.Payload) {
    self.receiver = receiver
    self.minApiVersion = minApiVersion
    self.payload = payload
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(receiver, forKey: .receiver)
    try container.encode(minApiVersion, forKey: .minApiVersion)

    switch payload {
    case .message(let message):
      var topLevelContainer = encoder.singleValueContainer()
      try topLevelContainer.encode(message)
    case .payment(let payment):
      try container.encode("payment", forKey: .kind)
      try container.encode(payment, forKey: .payment)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case receiver
    case kind = "type"
    case trackingData = "tracking_data"
    case minApiVersion = "min_api_version"
    case text
    case payment
  }
}

public struct SendMessageSuccess: Decodable {
  public let eventTypes: [BotEventType]

  private enum CodingKeys: String, CodingKey {
    case eventTypes = "event_types"
  }
}

public extension ViberBotApi {
  func sendMessage(_ parameters: SendMessageParams) -> AnyPublisher<ViberBotResponse<SendMessageSuccess>, Error> {
    dispatch(path: .sendMessage, parameters: parameters)
  }

  func sendMessage(
    _ parameters: SendMessageParams,
    completionQueue: DispatchQueue,
    completion: @escaping (Result<ViberBotResponse<SendMessageSuccess>, Error>) -> Void
  ) {
    dispatch(path: .sendMessage, parameters: parameters, completionQueue: completionQueue, completion: completion)
  }
}

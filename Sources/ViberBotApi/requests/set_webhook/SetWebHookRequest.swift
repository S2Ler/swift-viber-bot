import Foundation
import Networker
import ViberBotDataModels
import Combine

public extension RequestPath {
  static var setWebHook: RequestPath { "/set_webhook" }
}

public struct SetWebHookParams: Encodable {
  public let url: URL
  public let eventTypes: [BotEventType]?
  public let sendName: Bool
  public let sendPhoto: Bool

  public init(url: URL, eventTypes: [BotEventType]? = nil, sendName: Bool = false, sendPhoto: Bool = false) {
    self.url = url
    self.eventTypes = eventTypes
    self.sendName = sendName
    self.sendPhoto = sendPhoto
  }

  private enum CodingKeys: String, CodingKey {
    case url
    case eventTypes = "event_types"
    case sendName = "send_name"
    case sendPhoto = "send_photo"
  }
}

public struct SetWebHookSuccess: Decodable {
  public let eventTypes: [BotEventType]

  private enum CodingKeys: String, CodingKey {
    case eventTypes = "event_types"
  }
}

public extension ViberBotApi {
  func setWebHook(_ parameters: SetWebHookParams) -> AnyPublisher<ViberBotResponse<SetWebHookSuccess>, Error> {
    dispatch(path: .setWebHook, parameters: parameters)
  }

  func setWebHook(
    _ parameters: SetWebHookParams,
    completionQueue: DispatchQueue,
    completion: @escaping (Result<ViberBotResponse<SetWebHookSuccess>, Error>) -> Void
  ) {
    dispatch(path: .setWebHook, parameters: parameters, completionQueue: completionQueue, completion: completion)
  }
}

import Foundation
import ViberWebHook
import ViberBotApi
import Networker
import Logging
import ViberDefaultWebHook
import ViberBotDataModels

public final class ViberBot {
  public struct Config {
    public let webHook: ViberWebHook
    public let webHookUrl: URL
    public let authToken: String
    public let apiBaseUrl: ViberBotApi.BaseUrl
    public let apiDefaultTimeInterval: TimeInterval
    public let logger: Logger?

    public init(
      webHook: ViberWebHook,
      webHookUrl: URL,
      authToken: String,
      apiBaseUrl: ViberBotApi.BaseUrl,
      apiDefaultTimeInterval: TimeInterval,
      logger: Logger?
    ) {
      self.webHook = webHook
      self.webHookUrl = webHookUrl
      self.authToken = authToken
      self.apiBaseUrl = apiBaseUrl
      self.apiDefaultTimeInterval = apiDefaultTimeInterval
      self.logger = logger
    }
  }

  public enum CallbackResult {
    case payload(CallbackPayload)
    case rawMessage(String)
  }

  private let config: Config
  public let api: ViberBotApi

  private var logger: Logger? { config.logger }

  public init(_ config: Config) {
    self.config = config
    let dispatcher = URLSessionDispatcher(jsonBodyEncoder: ViberBotJsonEncoder(),
                                          plugins: [],
                                          logger: config.logger)
    let apiConfig = ViberBotApi.Config(
      baseUrl: config.apiBaseUrl,
      authToken: config.authToken,
      defaultTimeout: config.apiDefaultTimeInterval
    )
    self.api = .init(dispatcher: dispatcher, config: apiConfig)
  }

  public func start(
    completionQueue: DispatchQueue,
    callbackHandler: @escaping (CallbackResult, ViberBotApi) -> Void,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    DispatchQueue.global().async {
      self.config.webHook.listen { (message) in
        do {
          let decoder = JSONDecoder()
          let payload = try decoder.decode(CallbackPayload.self, from: Data(message.utf8))
          completionQueue.async {
            callbackHandler(.payload(payload), self.api)
          }
        }
        catch {
          self.logger?.error("Couldn't decode message with error: \(error)")
          completionQueue.async {
            // In case of an error just send raw message
            callbackHandler(.rawMessage(message), self.api)
          }
        }
      }
    }
    
    api.setWebHook(.init(url: config.webHookUrl), completionQueue: .global()) { [weak self]
      (result: Result<ViberBotResponse<SetWebHookSuccess>, Error>)  in
      completionQueue.async {
        completion(result.map({ _ in () }))
      }

      self?.logger?.info("Set web hook result: \(result)")
    }
  }
}

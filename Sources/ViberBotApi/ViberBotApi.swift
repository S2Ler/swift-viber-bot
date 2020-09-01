import Foundation
import Networker
import Combine

public class ViberBotApi {
  public struct BaseUrl {
    public let rawUrl: URL

    public init(rawUrl: URL) {
      self.rawUrl = rawUrl
    }

    public static var production: BaseUrl {
      .init(rawUrl: URL(string: "https://chatapi.viber.com/pa/")!)
    }
  }

  public struct Config {
    public let baseUrl: BaseUrl
    public let authToken: String
    public let defaultTimeout: TimeInterval

    public init(baseUrl: ViberBotApi.BaseUrl, authToken: String, defaultTimeout: TimeInterval) {
      self.baseUrl = baseUrl
      self.authToken = authToken
      self.defaultTimeout = defaultTimeout
    }
  }

  private let dispatcher: Dispatcher
  private let config: Config

  public init(dispatcher: Dispatcher, config: Config) {
    self.dispatcher = dispatcher
    self.config = config

    dispatcher.add(InjectHeaderPlugin(headerField: "X-Viber-Auth-Token",
                                      value: config.authToken))
  }

  public func dispatch<Parameters: Encodable, Success: Decodable>(
    path: RequestPath,
    parameters: Parameters,
    timeout: TimeInterval? = nil
  ) -> AnyPublisher<ViberBotResponse<Success>, Error> {
    dispatcher.dispatch(
      Request<ViberBotResponse<Success>, ViberBotResponseDecoder>(
        baseUrl: config.baseUrl.rawUrl,
        path: path,
        urlParams: nil,
        httpMethod: .post,
        body: .json(parameters),
        headers: nil,
        timeout: timeout ?? config.defaultTimeout,
        cachePolicy: .useProtocolCachePolicy
      )
    )
  }

  public func dispatch<Parameters: Encodable, Success: Decodable>(
    path: RequestPath,
    parameters: Parameters,
    timeout: TimeInterval? = nil,
    completionQueue: DispatchQueue,
    completion: @escaping (Result<ViberBotResponse<Success>, Error>) -> Void
  ) {
    dispatcher.dispatch(
      Request<ViberBotResponse<Success>, ViberBotResponseDecoder>(
        baseUrl: config.baseUrl.rawUrl,
        path: path,
        urlParams: nil,
        httpMethod: .post,
        body: .json(parameters),
        headers: nil,
        timeout: timeout ?? config.defaultTimeout,
        cachePolicy: .useProtocolCachePolicy
      ),
      completionQueue: completionQueue,
      completion: completion
    )
  }
}

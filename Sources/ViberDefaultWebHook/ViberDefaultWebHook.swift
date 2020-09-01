import Foundation
import ExpressSwift
import ViberWebHook

public final class ViberDefaultWebHook: ViberWebHook {
  public struct Config {
    public init(
      expressConfig: Express.Config,
      webHookPath: String,
      listenAddress: String
    ) {
      self.expressConfig = expressConfig
      self.webHookPath = webHookPath
      self.listenAddress = listenAddress
    }

    public let expressConfig: Express.Config
    public let webHookPath: String
    public let listenAddress: String
  }

  private let express: Express
  private let config: Config

  public init(_ config: Config) {
    self.config = config
    let express = Express(config: config.expressConfig)
    self.express = express
  }

  public func listen(messageHandler: @escaping (String) -> Void) {
    let route = Route(stringLiteral: config.webHookPath)
    express.use(route, .POST) { (request, response) -> Bool in
      // TODO: Verify signature
      defer {
        response.send("")
      }
      guard let data = request.body,
            let message = String(data: data, encoding: .utf8)
      else {
        response.status = .badRequest
        return true
      }

      messageHandler(message)

      return true
    }

    express.listen(443, config.listenAddress)
  }
}

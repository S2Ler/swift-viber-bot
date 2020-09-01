import Foundation

public enum ViberBotError: Swift.Error {
  case statusCodeError(HTTPURLResponse)
  case transportError(Swift.Error)
  case decodingError(Swift.Error)
}

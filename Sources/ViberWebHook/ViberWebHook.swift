import Foundation

public protocol ViberWebHook {  
  func listen(messageHandler: @escaping (String) -> Void)
}

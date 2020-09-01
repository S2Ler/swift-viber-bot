import Foundation

public enum BotEventType: String, Codable {
  case subscribed = "subscribed"
  case unsubscribed = "unsubscribed"
  case webhook = "webhook"
  case conversationStarted = "conversation_started"
  case action = "action"
  case delivered = "delivered"
  case failed = "failed"
  case message = "message"
  case seen = "seen"
  case clientStatus = "client_status"
}

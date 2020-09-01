import Foundation

public enum ViberBotResponse<Success: Decodable>: Decodable {
  case success(Success)
  case failure(status: Int, statusMessage: String)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let status = try container.decode(Int.self, forKey: .status)
    if status == 0 {
      self = .success(try Success(from: decoder))
    }
    else {
      let statusMessage = try container.decode(String.self, forKey: .statusMessage)
      self = .failure(status: status, statusMessage: statusMessage)
    }
  }

  private enum CodingKeys: String, CodingKey {
    case status
    case statusMessage = "status_message"
  }
}

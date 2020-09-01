import Foundation

public struct PaymentPayload: Codable {
  public enum Kind: String, Codable {
    case googlePay = "GooglePay"
    case applePay = "ApplePay"
    case unknown = "unknown"

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(rawValue)
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let rawValue = try container.decode(String.self)
      self = Kind(rawValue: rawValue) ?? .unknown
    }
  }

  public let kind: Kind
  public let description: String
  public let totalPrice: Decimal
  public let currencyCode: String
  public let paymentParameters: [[String: String]]

  public init(kind: PaymentPayload.Kind, description: String, totalPrice: Decimal, currencyCode: String, paymentParameters: [[String : String]]) {
    self.kind = kind
    self.description = description
    self.totalPrice = totalPrice
    self.currencyCode = currencyCode
    self.paymentParameters = paymentParameters
  }

  private enum CodingKeys: String, CodingKey {
    case kind = "type"
    case description
    case totalPrice = "total_price"
    case currencyCode = "currency_code"
    case paymentParameters = "payment_parameters"
  }
}

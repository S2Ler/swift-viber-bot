import Foundation

public struct MessageSender: Decodable {
    public let id: ViberUserId
    public let name: String
    public let avatar: URL?
    public let language: String
    public let country: String
    public let apiVersion: Int

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case avatar = "avatar"
        case language = "language"
        case country = "country"
        case apiVersion = "api_version"
    }
}

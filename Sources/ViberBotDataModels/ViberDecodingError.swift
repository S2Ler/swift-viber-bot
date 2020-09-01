import Foundation

public enum ViberDecodingError: LocalizedError {
    case unsupportedCallback(String)

    public var errorDescription: String? {
        switch self {
        case .unsupportedCallback(let message):
            return "Unsupported callback \(message)"
        }
    }
}

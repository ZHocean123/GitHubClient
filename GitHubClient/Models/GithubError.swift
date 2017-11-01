//
//  GithubError.swift
//  FBSnapshotTestCase
//
//  Created by yang on 26/10/2017.
//

public struct GithubError: Error {
    enum ErrorKind: CustomStringConvertible {
        case invalidRequest
        case jsonParseError(error: Error)
        case keychainError(code: OSStatus)
        case missingClient
        case netError(error: Error)
        case codeError(code: Int)
        case oauthError

        var description: String {
            switch self {
            case .invalidRequest:
                return "invalidRequest"
            case .jsonParseError(let error):
                return "jsonParseError(error: \(error)"
            case .keychainError(let code):
                return "keychainError(code: \(code))"
            case .missingClient:
                return "missingClient"
            case .netError(let error):
                return "netError(error: \(error))"
            case .codeError(let code):
                return "codeError(error: \(code))"
            case .oauthError:
                return "oauthError"
            }
        }
    }

    let kind: ErrorKind
    let message: String

    public var localizedDescription: String {
        return "[\(kind.description)] - \(message)"
    }
}

//
//  GithubError.swift
//  FBSnapshotTestCase
//
//  Created by yang on 26/10/2017.
//

public struct GithubError: Error {
    enum ErrorKind: CustomStringConvertible {
        case invalidRequest
        case jsonParseError
        case keychainError(code: OSStatus)
        case missingClient
        case netError(error: Error)

        var description: String {
            switch self {
            case .invalidRequest:
                return "invalidRequest"
            case .jsonParseError:
                return "jsonParseError"
            case .keychainError(let code):
                return "keychainError(code: \(code))"
            case .missingClient:
                return "missingClient"
            case .netError(let error):
                return "netError(error: \(error))"
            }
        }
    }

    let kind: ErrorKind
    let message: String

    public var localizedDescription: String {
        return "[\(kind.description)] - \(message)"
    }
}

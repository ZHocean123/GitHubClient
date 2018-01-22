//
//  Commit.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

import Foundation

public struct Commit: Codable {
    public let url: URL
    public let sha: String
    public let htmlUrl: URL?
    public let commentsUrl: URL?
    public struct Commit: Codable {
        public let url: URL
        public struct Author: Codable {
            public let name: String
            public let email: String
            public let username: String?
            public let date: String?
        }
        public let author: Author
        public struct Committer: Codable {
            public let name: String
            public let email: String
            public let username: String?
            public let date: String?
        }
        public let committer: Committer?
        public let message: String
        public struct Tree: Codable {
            public let url: URL
            public let sha: String
        }
        public let tree: Tree?
        public let commentCount: Int?
        public struct Verification: Codable {
            public let verified: Bool
            public let reason: String
            public let signature: String?
            public let payload: String?
        }
        public let verification: Verification?
        private enum CodingKeys: String, CodingKey {
            case url
            case author
            case committer
            case message
            case tree
            case commentCount = "comment_count"
            case verification
        }
    }
    public let commit: Commit?
    public let author: User
    public let committer: User
    public struct Parent: Codable {
        public let url: URL
        public let sha: String
    }
    public let parents: [Parent]
    private enum CodingKeys: String, CodingKey {
        case url
        case sha
        case htmlUrl = "html_url"
        case commentsUrl = "comments_url"
        case commit
        case author
        case committer
        case parents
    }
}

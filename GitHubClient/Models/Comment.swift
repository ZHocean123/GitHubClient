//
//  Comment.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

import Foundation

public struct Comment: Codable {
    public let url: URL
    public let htmlUrl: URL
    public let id: Int
    public let user: User
    public let position: String?
    public let line: String?
    public let path: String?
    public let commitId: String?
    public let createdAt: String
    public let updatedAt: String
    public let body: String
    private enum CodingKeys: String, CodingKey {
        case url
        case htmlUrl = "html_url"
        case id
        case user
        case position
        case line
        case path
        case commitId = "commit_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case body
    }
}

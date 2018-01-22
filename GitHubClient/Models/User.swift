//
//  User.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

import Foundation

public struct User: Codable {
    public let login: String
    public let id: Int
    public let avatarUrl: URL
    public let gravatarId: String
    public let htmlUrl: URL
    public let type: String
    public let siteAdmin: Bool
    public let name: String?
    public let company: String?
    public let blog: String?
    public let location: String?
    public let email: String?
    public let hireable: Bool?
    public let bio: String?
    public let publicRepos: Int?
    public let publicGists: Int?
    public let followers: Int?
    public let following: Int?
    public let createdAt: String?
    public let updatedAt: String?
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case htmlUrl = "html_url"
        case type
        case siteAdmin = "site_admin"
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

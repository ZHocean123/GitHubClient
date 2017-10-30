//
//  User.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

public struct User: Codable {
    public let login: String
    public let id: Int
    public let avatarUrl: URL
    public let gravatarId: String
    public let url: URL
    public let htmlUrl: URL
    public let followersUrl: URL
    public let followingUrl: String
    public let gistsUrl: String
    public let starredUrl: String
    public let subscriptionsUrl: URL
    public let organizationsUrl: URL
    public let reposUrl: URL
    public let eventsUrl: String
    public let receivedEventsUrl: URL
    public let type: String
    public let siteAdmin: Bool
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

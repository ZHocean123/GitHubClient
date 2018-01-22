//
//  Organization.swift
//  GitHubClient
//
//  Created by yang on 31/10/2017.
//

import Foundation

public struct Organization: Codable {
    public let login: String
    public let id: Int
    public let url: URL
    public let reposUrl: URL
    public let eventsUrl: URL
    public let hooksUrl: URL
    public let issuesUrl: URL
    public let membersUrl: String
    public let publicMembersUrl: String
    public let avatarUrl: URL
    public let description: String
    private enum CodingKeys: String, CodingKey {
        case login
        case id
        case url
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case hooksUrl = "hooks_url"
        case issuesUrl = "issues_url"
        case membersUrl = "members_url"
        case publicMembersUrl = "public_members_url"
        case avatarUrl = "avatar_url"
        case description
    }
}

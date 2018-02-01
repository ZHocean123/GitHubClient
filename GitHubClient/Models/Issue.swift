//
//  Issue.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

import Foundation

public enum IssueState: String {
    case open
    case cloased
    case all
}

public struct Issue: Codable {
    public let id: Int
    public let url: URL
    public let repositoryUrl: URL
    public let labelsUrl: String
    public let commentsUrl: URL
    public let eventsUrl: URL
    public let htmlUrl: URL
    public let number: Int
    public let state: String
    public let title: String
    public let body: String?
    public let user: User
    public struct Label: Codable {
        public let id: Int
        public let url: URL
        public let name: String
        public let color: String
        public let `default`: Bool
    }
    public let labels: [Label]
    public let assignee: User?
    public let assignees: [User]
    public let milestone: Milestone?
    public let locked: Bool
    public let comments: Int
    public struct PullRequest: Codable {
        public let url: URL
        public let htmlUrl: URL
        public let diffUrl: URL
        public let patchUrl: URL
        private enum CodingKeys: String, CodingKey {
            case url
            case htmlUrl = "html_url"
            case diffUrl = "diff_url"
            case patchUrl = "patch_url"
        }
    }
    public let pullRequest: PullRequest?
    public let closedAt: String?
    public let createdAt: String
    public let updatedAt: String
    public let authorAssociation: String
    public let repository: Repository?
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case repositoryUrl = "repository_url"
        case labelsUrl = "labels_url"
        case commentsUrl = "comments_url"
        case eventsUrl = "events_url"
        case htmlUrl = "html_url"
        case number
        case state
        case title
        case body
        case user
        case labels
        case assignee
        case assignees
        case milestone
        case locked
        case comments
        case pullRequest = "pull_request"
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authorAssociation = "author_association"
        case repository
    }
}

public struct IssueComment: Codable {
    public let url: URL
    public let htmlUrl: URL
    public let issueUrl: URL
    public let id: Int
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
    public let user: User
    public let createdAt: String
    public let updatedAt: String
    public let authorAssociation: String
    public let body: String
    private enum CodingKeys: String, CodingKey {
        case url
        case htmlUrl = "html_url"
        case issueUrl = "issue_url"
        case id
        case user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authorAssociation = "author_association"
        case body
    }
}

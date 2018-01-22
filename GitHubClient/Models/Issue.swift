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

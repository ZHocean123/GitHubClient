//
//  Repository.swift
//  MyGithub
//
//  Created by yang on 11/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

public enum RepositoryVisibility: String {
    case all = "all"
    case `public` = "public"
    case `private` = "private"
}

public struct RepositoryAffiliation: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let owner = RepositoryAffiliation(rawValue: 1 << 0)
    public static let collaborator = RepositoryAffiliation(rawValue: 1 << 1)
    public static let organizationMember = RepositoryAffiliation(rawValue: 1 << 2)
    public static let `default`: RepositoryAffiliation = [.owner, .collaborator, .organizationMember]

    public var stringValue: String {
        var str = ""
        if self.contains(.owner) {
            str += "owner"
        }
        if self.contains(.collaborator) {
            str += str.count > 0 ? "," : ""
            str += "collaborator"
        }
        if self.contains(.organizationMember) {
            str += str.count > 0 ? "," : ""
            str += "organization_member"
        }
        return str
    }
}

public enum RepositoryType: String {
    case all = "all"
    case owner = "owner"
    case `public` = "public"
    case `private` = "private"
    case member = "member"
}

public enum RepositorySortType: String {
    case created = "created"
    case updated = "updated"
    case pushed = "pushed"
    case fullName = "full_name"
}

public enum RepositoryDirection: String {
    case asc = "asc"
    case desc = "desc"
}

public struct Repository: Codable {
    public let keysUrl: String
    public let statusesUrl: String
    public let issuesUrl: String
    public let defaultBranch: String
    public let issueEventsUrl: String
    public let hasProjects: Bool
    public let id: Int
    public let score: Double?
    public let owner: User
    public let eventsUrl: URL
    public let subscriptionUrl: URL
    public let watchers: Int
    public let gitCommitsUrl: String
    public let subscribersUrl: URL
    public let cloneUrl: URL
    public let hasWiki: Bool
    public let url: URL
    public let pullsUrl: String
    public let fork: Bool
    public let notificationsUrl: String
    public let description: String?
    public let collaboratorsUrl: String
    public let deploymentsUrl: URL
    public let languagesUrl: URL
    public let hasIssues: Bool
    public let commentsUrl: String
    public let `private`: Bool
    public let size: Int
    public let gitTagsUrl: String
    public let updatedAt: String
    public let sshUrl: String
    public let name: String
    public let contentsUrl: String
    public let archiveUrl: String
    public let milestonesUrl: String
    public let blobsUrl: String
    public let contributorsUrl: URL
    public let openIssuesCount: Int
    public struct Permissions: Codable {
        public let admin: Bool
        public let push: Bool
        public let pull: Bool
    }
    public let permissions: Permissions?
    public let forksCount: Int
    public let treesUrl: String
    public let svnUrl: URL
    public let commitsUrl: String
    public let createdAt: String
    public let forksUrl: URL
    public let hasDownloads: Bool
    public let mirrorUrl: URL?
    public let homepage: String?
    public let teamsUrl: URL
    public let branchesUrl: String
    public let issueCommentUrl: String
    public let mergesUrl: URL
    public let gitRefsUrl: String
    public let gitUrl: URL
    public let forks: Int
    public let openIssues: Int
    public let hooksUrl: URL
    public let htmlUrl: URL
    public let stargazersUrl: URL
    public let assigneesUrl: String
    public let compareUrl: String
    public let fullName: String
    public let tagsUrl: URL
    public let releasesUrl: String
    public let pushedAt: String
    public let labelsUrl: String
    public let downloadsUrl: URL
    public let stargazersCount: Int
    public let watchersCount: Int
    public let language: String?
    public let hasPages: Bool
    public let topics: [String]?
    private enum CodingKeys: String, CodingKey {
        case keysUrl = "keys_url"
        case statusesUrl = "statuses_url"
        case issuesUrl = "issues_url"
        case defaultBranch = "default_branch"
        case issueEventsUrl = "issue_events_url"
        case hasProjects = "has_projects"
        case id
        case score
        case owner
        case eventsUrl = "events_url"
        case subscriptionUrl = "subscription_url"
        case watchers
        case gitCommitsUrl = "git_commits_url"
        case subscribersUrl = "subscribers_url"
        case cloneUrl = "clone_url"
        case hasWiki = "has_wiki"
        case url
        case pullsUrl = "pulls_url"
        case fork
        case notificationsUrl = "notifications_url"
        case description
        case collaboratorsUrl = "collaborators_url"
        case deploymentsUrl = "deployments_url"
        case languagesUrl = "languages_url"
        case hasIssues = "has_issues"
        case commentsUrl = "comments_url"
        case `private` = "private"
        case size
        case gitTagsUrl = "git_tags_url"
        case updatedAt = "updated_at"
        case sshUrl = "ssh_url"
        case name
        case contentsUrl = "contents_url"
        case archiveUrl = "archive_url"
        case milestonesUrl = "milestones_url"
        case blobsUrl = "blobs_url"
        case contributorsUrl = "contributors_url"
        case openIssuesCount = "open_issues_count"
        case permissions
        case forksCount = "forks_count"
        case treesUrl = "trees_url"
        case svnUrl = "svn_url"
        case commitsUrl = "commits_url"
        case createdAt = "created_at"
        case forksUrl = "forks_url"
        case hasDownloads = "has_downloads"
        case mirrorUrl = "mirror_url"
        case homepage
        case teamsUrl = "teams_url"
        case branchesUrl = "branches_url"
        case issueCommentUrl = "issue_comment_url"
        case mergesUrl = "merges_url"
        case gitRefsUrl = "git_refs_url"
        case gitUrl = "git_url"
        case forks
        case openIssues = "open_issues"
        case hooksUrl = "hooks_url"
        case htmlUrl = "html_url"
        case stargazersUrl = "stargazers_url"
        case assigneesUrl = "assignees_url"
        case compareUrl = "compare_url"
        case fullName = "full_name"
        case tagsUrl = "tags_url"
        case releasesUrl = "releases_url"
        case pushedAt = "pushed_at"
        case labelsUrl = "labels_url"
        case downloadsUrl = "downloads_url"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case hasPages = "has_pages"
        case topics = "topics"
    }
}

public struct SearchRepositoryResult: Codable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [Repository]
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

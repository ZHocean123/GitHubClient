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
    
    static let owner = RepositoryAffiliation(rawValue: 1 << 0)
    static let collaborator = RepositoryAffiliation(rawValue: 1 << 1)
    static let organizationMember = RepositoryAffiliation(rawValue: 1 << 2)
    static let `default`: RepositoryAffiliation = [.owner, .collaborator, .organizationMember]

    var stringValue: String {
        var str = ""
        if self.contains(.owner) {
            str += "owner"
        }
        if self.contains(.collaborator) {
            str += str.characters.count > 0 ? "," : ""
            str += "collaborator"
        }
        if self.contains(.organizationMember) {
            str += str.characters.count > 0 ? "," : ""
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
    let keysUrl: String
    let statusesUrl: String
    let issuesUrl: String
    let defaultBranch: String
    let issueEventsUrl: String
    let hasProjects: Bool
    let id: Int
    let score: Double?
    struct Owner: Codable {
        let id: Int
        let organizationsUrl: URL
        let receivedEventsUrl: URL
        let followingUrl: String
        let login: String
        let avatarUrl: URL
        let url: URL
        let subscriptionsUrl: URL
        let type: String
        let reposUrl: URL
        let htmlUrl: URL
        let eventsUrl: String
        let siteAdmin: Bool
        let starredUrl: String
        let gistsUrl: String
        let gravatarId: String
        let followersUrl: URL
        private enum CodingKeys: String, CodingKey {
            case id
            case organizationsUrl = "organizations_url"
            case receivedEventsUrl = "received_events_url"
            case followingUrl = "following_url"
            case login
            case avatarUrl = "avatar_url"
            case url
            case subscriptionsUrl = "subscriptions_url"
            case type
            case reposUrl = "repos_url"
            case htmlUrl = "html_url"
            case eventsUrl = "events_url"
            case siteAdmin = "site_admin"
            case starredUrl = "starred_url"
            case gistsUrl = "gists_url"
            case gravatarId = "gravatar_id"
            case followersUrl = "followers_url"
        }
    }
    let owner: Owner
    let eventsUrl: URL
    let subscriptionUrl: URL
    let watchers: Int
    let gitCommitsUrl: String
    let subscribersUrl: URL
    let cloneUrl: URL
    let hasWiki: Bool
    let url: URL
    let pullsUrl: String
    let fork: Bool
    let notificationsUrl: String
    let description: String?
    let collaboratorsUrl: String
    let deploymentsUrl: URL
    let languagesUrl: URL
    let hasIssues: Bool
    let commentsUrl: String
    let `private`: Bool
    let size: Int
    let gitTagsUrl: String
    let updatedAt: String
    let sshUrl: String
    let name: String
    let contentsUrl: String
    let archiveUrl: String
    let milestonesUrl: String
    let blobsUrl: String
    let contributorsUrl: URL
    let openIssuesCount: Int
    struct Permissions: Codable {
        let admin: Bool
        let push: Bool
        let pull: Bool
    }
    let permissions: Permissions
    let forksCount: Int
    let treesUrl: String
    let svnUrl: URL
    let commitsUrl: String
    let createdAt: String
    let forksUrl: URL
    let hasDownloads: Bool
    let mirrorUrl: URL?
    let homepage: String?
    let teamsUrl: URL
    let branchesUrl: String
    let issueCommentUrl: String
    let mergesUrl: URL
    let gitRefsUrl: String
    let gitUrl: URL
    let forks: Int
    let openIssues: Int
    let hooksUrl: URL
    let htmlUrl: URL
    let stargazersUrl: URL
    let assigneesUrl: String
    let compareUrl: String
    let fullName: String
    let tagsUrl: URL
    let releasesUrl: String
    let pushedAt: String
    let labelsUrl: String
    let downloadsUrl: URL
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let hasPages: Bool
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
    }
}

public struct SearchRepositoryResult: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

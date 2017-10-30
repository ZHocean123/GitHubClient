//
//  PullRequest.swift
//  GitHubClient
//
//  Created by yang on 30/10/2017.
//

public struct PullRequest: Codable {
    public let url: URL
    public let id: Int
    public let htmlUrl: URL
    public let diffUrl: URL
    public let patchUrl: URL
    public let issueUrl: URL
    public let number: Int
    public let state: String
    public let locked: Bool
    public let title: String
    public let user: User
    public let body: String
    public let createdAt: String
    public let updatedAt: String
    public let closedAt: String
    public let mergedAt: String
    public let mergeCommitSha: String
    public let assignee: String?
    public let assignees: [String]
    public let requestedReviewers: [String]
    public let milestone: String?
    public let commitsUrl: URL
    public let reviewCommentsUrl: URL
    public let reviewCommentUrl: String
    public let commentsUrl: URL
    public let statusesUrl: URL
    public struct Head: Codable {
        public let label: String
        public let ref: String
        public let sha: String
        public let user: User
        public let repo: Repository
    }
    public let head: Head
    public struct Base: Codable {
        public let label: String
        public let ref: String
        public let sha: String
        public let user: User
        public let repo: Repository
    }
    public let base: Base
    public struct Links: Codable {
        public struct LinkSelf: Codable {
            public let href: URL
        }
        public let `self`: LinkSelf
        public struct Html: Codable {
            public let href: URL
        }
        public let html: Html
        public struct Issue: Codable {
            public let href: URL
        }
        public let issue: Issue
        public struct Comments: Codable {
            public let href: URL
        }
        public let comments: Comments
        public struct ReviewComments: Codable {
            public let href: URL
        }
        public let reviewComments: ReviewComments
        public struct ReviewComment: Codable {
            public let href: String
        }
        public let reviewComment: ReviewComment
        public struct Commits: Codable {
            public let href: URL
        }
        public let commits: Commits
        public struct Statuses: Codable {
            public let href: URL
        }
        public let statuses: Statuses
        private enum CodingKeys: String, CodingKey {
            case `self` = "self"
            case html
            case issue
            case comments
            case reviewComments = "review_comments"
            case reviewComment = "review_comment"
            case commits
            case statuses
        }
    }
    public let links: Links
    public let authorAssociation: String
    public let merged: Bool
    public let mergeable: Bool?
    public let rebaseable: Bool?
    public let mergeableState: String
    public let mergedBy: User
    public let comments: Int
    public let reviewComments: Int
    public let maintainerCanModify: Bool
    public let commits: Int
    public let additions: Int
    public let deletions: Int
    public let changedFiles: Int
    private enum CodingKeys: String, CodingKey {
        case url
        case id
        case htmlUrl = "html_url"
        case diffUrl = "diff_url"
        case patchUrl = "patch_url"
        case issueUrl = "issue_url"
        case number
        case state
        case locked
        case title
        case user
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case mergedAt = "merged_at"
        case mergeCommitSha = "merge_commit_sha"
        case assignee
        case assignees
        case requestedReviewers = "requested_reviewers"
        case milestone
        case commitsUrl = "commits_url"
        case reviewCommentsUrl = "review_comments_url"
        case reviewCommentUrl = "review_comment_url"
        case commentsUrl = "comments_url"
        case statusesUrl = "statuses_url"
        case head
        case base
        case links = "_links"
        case authorAssociation = "author_association"
        case merged
        case mergeable
        case rebaseable
        case mergeableState = "mergeable_state"
        case mergedBy = "merged_by"
        case comments
        case reviewComments = "review_comments"
        case maintainerCanModify = "maintainer_can_modify"
        case commits
        case additions
        case deletions
        case changedFiles = "changed_files"
    }
}

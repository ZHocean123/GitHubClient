//
//  Event.swift
//  DynamicColor
//
//  Created by yang on 30/10/2017.
//

public struct Event: Codable {
    public let id: String
    public enum `Type`: String, Codable {
        case commitCommentEvent = "CommitCommentEvent"
        case createEvent = "CreateEvent"
        case deleteEvent = "DeleteEvent"
        case deploymentEvent = "DeploymentEvent"
        case deploymentStatusEvent = "DeploymentStatusEvent"
        case downloadEvent = "DownloadEvent"
        case followEvent = "FollowEvent"
        case forkEvent = "ForkEvent"
        case forkApplyEvent = "ForkApplyEvent"
        case gistEvent = "GistEvent"
        case gollumEvent = "GollumEvent"
        case installationEvent = "InstallationEvent"
        case installationRepositoriesEvent = "InstallationRepositoriesEvent"
        case issueCommentEvent = "IssueCommentEvent"
        case issuesEvent = "IssuesEvent"
        case labelEvent = "LabelEvent"
        case marketplacePurchaseEvent = "MarketplacePurchaseEvent"
        case memberEvent = "MemberEvent"
        case membershipEvent = "MembershipEvent"
        case milestoneEvent = "MilestoneEvent"
        case organizationEvent = "OrganizationEvent"
        case orgBlockEvent = "OrgBlockEvent"
        case pageBuildEvent = "PageBuildEvent"
        case projectCardEvent = "ProjectCardEvent"
        case projectColumnEvent = "ProjectColumnEvent"
        case projectEvent = "ProjectEvent"
        case publicEvent = "PublicEvent"
        case pullRequestEvent = "PullRequestEvent"
        case pullRequestReviewEvent = "PullRequestReviewEvent"
        case pullRequestReviewCommentEvent = "PullRequestReviewCommentEvent"
        case pushEvent = "PushEvent"
        case releaseEvent = "ReleaseEvent"
        case repositoryEvent = "RepositoryEvent"
        case statusEvent = "StatusEvent"
        case teamEvent = "TeamEvent"
        case teamAddEvent = "TeamAddEvent"
        case watchEvent = "WatchEvent"
    }
    public let type: Type
    public struct Actor: Codable {
        public let id: Int
        public let login: String
        public let displayLogin: String
        public let gravatarId: String
        public let url: URL
        public let avatarUrl: URL
        private enum CodingKeys: String, CodingKey {
            case id
            case login
            case displayLogin = "display_login"
            case gravatarId = "gravatar_id"
            case url
            case avatarUrl = "avatar_url"
        }
    }
    public let actor: Actor
    public struct Repo: Codable {
        public let id: Int
        public let name: String
        public let url: URL
    }
    public let repo: Repo
    public struct Payload: Codable {
        public let action: String?
        public let issue: Issue?
        public let comment: Comment?
        public let ref: String?
        public let refType: String?
        public let masterBranch: String?
        public let description: String?
        public let pusherType: String?
        public let pushId: Date?
        public let size: Int?
        public let distinctSize: Int?
        public let head: String?
        public let before: String?
        public let commits: [Commit.Commit]?
        public let number: Int?
        public let pullRequest: PullRequest?
        private enum CodingKeys: String, CodingKey {
            case action
            case issue
            case comment
            case ref
            case refType = "ref_type"
            case masterBranch = "master_branch"
            case description
            case pusherType = "pusher_type"
            case pushId = "push_id"
            case size
            case distinctSize = "distinct_size"
            case head
            case before
            case commits
            case number
            case pullRequest = "pull_request"
        }
    }
    public let payload: Payload
    public let `public`: Bool
    public let createdAt: String
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case actor
        case repo
        case payload
        case `public` = "public"
        case createdAt = "created_at"
    }
}

//
//  Event.swift
//  DynamicColor
//
//  Created by yang on 30/10/2017.
//

public struct Event: Decodable {
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

//        var type: Decodable.Type {
//            switch self {
//            case .commitCommentEvent:
//                return CommitCommentEvent.self
//            case .createEvent:
//                return CreateEvent.self
//            default:
//                return CommitCommentEvent.self
//            }
//        }

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
    public enum Payload {
        case commitCommentEvent(event: CommitCommentEvent)
        case createEvent(event: CreateEvent)
        case deleteEvent(event: DeleteEvent)
        case deploymentEvent(event: DeploymentEvent)
        case deploymentStatusEvent(event: DeploymentStatusEvent)
        case downloadEvent
        case followEvent
        case forkEvent(event: ForkEvent)
        case forkApplyEvent
        case gistEvent(event: CommitCommentEvent)
        case gollumEvent(event: GollumEvent)
        case installationEvent(event: InstallationEvent)
        case installationRepositoriesEvent(event: InstallationRepositoriesEvent)
        case issueCommentEvent(event: IssueCommentEvent)
        case issuesEvent(event: IssuesEvent)
        case labelEvent(event: LabelEvent)
        case marketplacePurchaseEvent(event: CommitCommentEvent)
        case memberEvent(event: MemberEvent)
        case membershipEvent(event: CommitCommentEvent)
        case milestoneEvent(event: CommitCommentEvent)
        case organizationEvent(event: CommitCommentEvent)
        case orgBlockEvent(event: CommitCommentEvent)
        case pageBuildEvent(event: CommitCommentEvent)
        case projectCardEvent(event: CommitCommentEvent)
        case projectColumnEvent(event: CommitCommentEvent)
        case projectEvent(event: CommitCommentEvent)
        case publicEvent(event: CommitCommentEvent)
        case pullRequestEvent(event: PullRequestEvent)
        case pullRequestReviewEvent(event: CommitCommentEvent)
        case pullRequestReviewCommentEvent(event: CommitCommentEvent)
        case pushEvent(event: PushEvent)
        case releaseEvent(event: CommitCommentEvent)
        case repositoryEvent(event: CommitCommentEvent)
        case statusEvent(event: CommitCommentEvent)
        case teamEvent(event: CommitCommentEvent)
        case teamAddEvent(event: CommitCommentEvent)
        case watchEvent(event: CommitCommentEvent)
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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(Type.self, forKey: .type)
        actor = try container.decode(Actor.self, forKey: .actor)
        repo = try container.decode(Repo.self, forKey: .repo)
        `public` = try container.decode(Bool.self, forKey: .public)
        createdAt = try container.decode(String.self, forKey: .createdAt)

        switch type {
        case .commitCommentEvent:
            let event = try container.decode(CommitCommentEvent.self, forKey: .payload)
            payload = .commitCommentEvent(event: event)
        case .createEvent:
            let event = try container.decode(CreateEvent.self, forKey: .payload)
            payload = .createEvent(event: event)
        case .deleteEvent:
            let event = try container.decode(DeleteEvent.self, forKey: .payload)
            payload = .deleteEvent(event: event)
        case .deploymentEvent:
            let event = try container.decode(DeploymentEvent.self, forKey: .payload)
            payload = .deploymentEvent(event: event)
        case .deploymentStatusEvent:
            let event = try container.decode(DeploymentStatusEvent.self, forKey: .payload)
            payload = .deploymentStatusEvent(event: event)
        case .forkEvent:
            let event = try container.decode(ForkEvent.self, forKey: .payload)
            payload = .forkEvent(event: event)
        case .gollumEvent:
            let event = try container.decode(GollumEvent.self, forKey: .payload)
            payload = .gollumEvent(event: event)
        case .installationEvent:
            let event = try container.decode(InstallationEvent.self, forKey: .payload)
            payload = .installationEvent(event: event)
        case .installationRepositoriesEvent:
            let event = try container.decode(InstallationRepositoriesEvent.self, forKey: .payload)
            payload = .installationRepositoriesEvent(event: event)
        case .issueCommentEvent:
            let event = try container.decode(IssueCommentEvent.self, forKey: .payload)
            payload = .issueCommentEvent(event: event)
        case .issuesEvent:
            let event = try container.decode(IssuesEvent.self, forKey: .payload)
            payload = .issuesEvent(event: event)
        case .labelEvent:
            let event = try container.decode(LabelEvent.self, forKey: .payload)
            payload = .labelEvent(event: event)
        case .memberEvent:
            let event = try container.decode(MemberEvent.self, forKey: .payload)
            payload = .memberEvent(event: event)
        case .pushEvent:
            let event = try container.decode(PushEvent.self, forKey: .payload)
            payload = .pushEvent(event: event)
        case .pullRequestEvent:
            let event = try container.decode(PullRequestEvent.self, forKey: .payload)
            payload = .pullRequestEvent(event: event)
        default:
            throw GithubError(kind: .jsonParseError, message: "")
        }
    }
}

public struct CommitCommentEvent: Codable {
    public let action: String
    public let comment: Comment
    public let repository: Repository
    public let sender: User
}

public struct CreateEvent: Codable {
    public let ref: String
    public enum RefType: String, Codable {
        case repository
        case branch
        case tag
    }
    public let refType: RefType
    public let masterBranch: String
    public let description: String
    public let pusherType: String
    public let repository: Repository
    public let sender: User
    private enum CodingKeys: String, CodingKey {
        case ref
        case refType = "ref_type"
        case masterBranch = "master_branch"
        case description
        case pusherType = "pusher_type"
        case repository
        case sender
    }
}

public struct DeleteEvent: Codable {
    public let ref: String
    public enum RefType: String, Codable {
        case branch
        case tag
    }
    public let refType: RefType
    public let pusherType: String
    public let repository: Repository
    public let sender: User
    private enum CodingKeys: String, CodingKey {
        case ref
        case refType = "ref_type"
        case pusherType = "pusher_type"
        case repository
        case sender
    }
}

public struct DeploymentEvent: Codable {
    public struct Deployment: Codable {
        public let url: URL
        public let id: Int
        public let sha: String
        public let ref: String
        public let task: String
        public struct Payload: Codable {
        }
        public let payload: Payload
        public let environment: String
        public let description: String?
        public let creator: User
        public let createdAt: String
        public let updatedAt: String
        public let statusesUrl: URL
        public let repositoryUrl: URL
        private enum CodingKeys: String, CodingKey {
            case url
            case id
            case sha
            case ref
            case task
            case payload
            case environment
            case description
            case creator
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case statusesUrl = "statuses_url"
            case repositoryUrl = "repository_url"
        }
    }
    public let deployment: Deployment
    public let repository: Repository
    public let sender: User
}

public struct DeploymentStatusEvent: Codable {
    public struct DeploymentStatus: Codable {
        public let url: URL
        public let id: Int
        public let state: String
        public let creator: User
        public let description: String?
        public let targetUrl: URL?
        public let createdAt: String
        public let updatedAt: String
        public let deploymentUrl: URL
        public let repositoryUrl: URL
        private enum CodingKeys: String, CodingKey {
            case url
            case id
            case state
            case creator
            case description
            case targetUrl = "target_url"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case deploymentUrl = "deployment_url"
            case repositoryUrl = "repository_url"
        }
    }
    public let deploymentStatus: DeploymentStatus
    public struct Deployment: Codable {
        public let url: URL
        public let id: Int
        public let sha: String
        public let ref: String
        public let task: String
        public struct Payload: Codable {
        }
        public let payload: Payload
        public let environment: String
        public let description: String?
        public let creator: User
        public let createdAt: String
        public let updatedAt: String
        public let statusesUrl: URL
        public let repositoryUrl: URL
        private enum CodingKeys: String, CodingKey {
            case url
            case id
            case sha
            case ref
            case task
            case payload
            case environment
            case description
            case creator
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case statusesUrl = "statuses_url"
            case repositoryUrl = "repository_url"
        }
    }
    public let deployment: Deployment
    public let repository: Repository
    public let sender: User
    private enum CodingKeys: String, CodingKey {
        case deploymentStatus = "deployment_status"
        case deployment
        case repository
        case sender
    }
}

public struct ForkEvent: Codable {
    public let forkee: Repository
    public let repository: Repository
    public let sender: User
}

public struct GollumEvent: Codable {
    public struct Page: Codable {
        public let pageName: String
        public let title: String
        public let summary: String?
        public let action: String
        public let sha: String
        public let htmlUrl: URL
        private enum CodingKeys: String, CodingKey {
            case pageName = "page_name"
            case title
            case summary
            case action
            case sha
            case htmlUrl = "html_url"
        }
    }
    public let pages: [Page]
    public let repository: Repository
    public let sender: User
}

public struct InstallationEvent: Codable {
    public let action: String
    public struct Installation: Codable {
        public let id: Int
        public let account: User
        public let repositorySelection: String
        public let accessTokensUrl: URL
        public let repositoriesUrl: URL
        private enum CodingKeys: String, CodingKey {
            case id
            case account
            case repositorySelection = "repository_selection"
            case accessTokensUrl = "access_tokens_url"
            case repositoriesUrl = "repositories_url"
        }
    }
    public let installation: Installation
    public let sender: User
}

public struct InstallationRepositoriesEvent: Codable {
    public enum Action: String, Codable {
        case created
        case edited
        case deleted
    }
    public let action: Action
    public struct Installation: Codable {
        public let id: Int
        public let account: User
        public let repositorySelection: String
        public let accessTokensUrl: URL
        public let repositoriesUrl: URL
        public let htmlUrl: URL
        private enum CodingKeys: String, CodingKey {
            case id
            case account
            case repositorySelection = "repository_selection"
            case accessTokensUrl = "access_tokens_url"
            case repositoriesUrl = "repositories_url"
            case htmlUrl = "html_url"
        }
    }
    public let installation: Installation
    public let repositorySelection: String
    public struct Repositoriy: Codable {
        public let id: Int
        public let name: String
        public let fullName: String
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case fullName = "full_name"
        }
    }
    public let repositoriesAdded: [Repositoriy]
    public let repositoriesRemoved: [Repositoriy]
    public let sender: User
    private enum CodingKeys: String, CodingKey {
        case action
        case installation
        case repositorySelection = "repository_selection"
        case repositoriesAdded = "repositories_added"
        case repositoriesRemoved = "repositories_removed"
        case sender
    }
}

public struct IssueCommentEvent: Codable {
    public enum Action: String, Codable {
        case created
        case edited
        case deleted
    }
    public let action: Action
    public let issue: Issue
    public let comment: Comment
    public let repository: Repository?
    public let sender: User?
}

public struct IssuesEvent: Codable {
    public enum Action: String, Codable {
        case assigned
        case unassigned
        case labeled
        case unlabeled
        case opened
        case edited
        case milestoned
        case demilestoned
        case closed
        case reopened
    }
    public let action: Action
    public let issue: Issue
    public let repository: Repository?
    public let sender: User?
}

public struct LabelEvent: Codable {
    public enum Action: String, Codable {
        case created
        case edited
        case deleted
    }
    public let action: Action
    public struct Label: Codable {
        let url: URL
        let name: String
        let color: String
    }
    public let label: Label
    public let repository: Repository
    public let organization: Organization
    public let sender: User
}

public struct MemberEvent: Codable {
    public enum Action: String, Codable {
        case added
        case deleted
        case edited
    }
    public let action: Action
    public struct Member: Codable {
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
    public let member: Member
    public let repository: Repository?
    public let sender:User?
}

public struct PushEvent: Codable {
    public let pushId: Int
    public let size: Int
    public let distinctSize: Int
    public let ref: String
    public let head: String
    public let before: String
    public struct Commit: Codable {
        public let sha: String
        public struct Author: Codable {
            public let email: String
            public let name: String
        }
        public let author: Author
        public let message: String
        public let distinct: Bool
        public let url: URL
    }
    public let commits: [Commit]
    private enum CodingKeys: String, CodingKey {
        case pushId = "push_id"
        case size
        case distinctSize = "distinct_size"
        case ref
        case head
        case before
        case commits
    }
}

public struct PullRequestEvent: Codable {
    public enum Action: String, Codable {
        case assigned
        case unassigned
        case reviewRequested = "review_requested"
        case reviewRequestRemoved = "review_request_removed"
        case labeled
        case unlabeled
        case opened
        case edited
        case closed
        case reopened
    }
    public let action: Action
    public let number: Int
    public let pullRequest: PullRequest
    private enum CodingKeys: String, CodingKey {
        case action
        case number
        case pullRequest = "pull_request"
    }
}

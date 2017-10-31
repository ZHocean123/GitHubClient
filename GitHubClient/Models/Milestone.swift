//
//  Milestone.swift
//  GitHubClient
//
//  Created by yang on 31/10/2017.
//

public struct Milestone: Codable {
    public let url: URL
    public let htmlUrl: URL
    public let labelsUrl: URL
    public let id: Int
    public let number: Int
    public let state: String
    public let title: String
    public let description: String
    public let creator: User
    public let openIssues: Int
    public let closedIssues: Int
    public let createdAt: String
    public let updatedAt: String
    public let closedAt: String
    public let dueOn: String
    private enum CodingKeys: String, CodingKey {
        case url
        case htmlUrl = "html_url"
        case labelsUrl = "labels_url"
        case id
        case number
        case state
        case title
        case description
        case creator
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case dueOn = "due_on"
    }
}

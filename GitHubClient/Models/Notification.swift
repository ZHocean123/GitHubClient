//
//  Notification.swift
//  CFNotify
//
//  Created by yang on 02/11/2017.
//

import Foundation

public struct Notification: Codable {
    public let id: String
    public let unread: Bool
    public let reason: String
    public let updatedAt: String
    public let lastReadAt: String?
    public struct Subject: Codable {
        public let title: String
        public let url: URL
        public let latestCommentUrl: URL?
        public let type: String
        private enum CodingKeys: String, CodingKey {
            case title
            case url
            case latestCommentUrl = "latest_comment_url"
            case type
        }
    }
    public let subject: Subject
    public struct Repository: Codable {
        public let id: Int
        public let owner: User
        public let url: URL
        public let name: String
        public let fullName: String
        private enum CodingKeys: String, CodingKey {
            case id
            case owner
            case url
            case name
            case fullName = "full_name"
        }
    }
    public let repository: Repository
    public let url: URL
    public let subscriptionUrl: URL
    private enum CodingKeys: String, CodingKey {
        case id
        case unread
        case reason
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case subject
        case repository
        case url
        case subscriptionUrl = "subscription_url"
    }
}

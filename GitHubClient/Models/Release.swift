//
//  Release.swift
//  CFNotify
//
//  Created by yang on 02/11/2017.
//

public struct Release: Codable {
    public let url: URL
    public let htmlUrl: URL
    public let assetsUrl: URL
    public let uploadUrl: String
    public let tarballUrl: URL
    public let zipballUrl: URL
    public let id: Int
    public let tagName: String
    public let targetCommitish: String
    public let name: String
    public let body: String
    public let draft: Bool
    public let prerelease: Bool
    public let createdAt: String
    public let publishedAt: String
    public let author: User
    public struct Asset: Codable {
        public let url: URL
        public let browserDownloadUrl: URL
        public let id: Int
        public let name: String
        public let label: String
        public let state: String
        public let contentType: String
        public let size: Int
        public let downloadCount: Int
        public let createdAt: String
        public let updatedAt: String
        public let uploader: User
        private enum CodingKeys: String, CodingKey {
            case url
            case browserDownloadUrl = "browser_download_url"
            case id
            case name
            case label
            case state
            case contentType = "content_type"
            case size
            case downloadCount = "download_count"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case uploader
        }
    }
    public let assets: [Asset]
    private enum CodingKeys: String, CodingKey {
        case url
        case htmlUrl = "html_url"
        case assetsUrl = "assets_url"
        case uploadUrl = "upload_url"
        case tarballUrl = "tarball_url"
        case zipballUrl = "zipball_url"
        case id
        case tagName = "tag_name"
        case targetCommitish = "target_commitish"
        case name
        case body
        case draft
        case prerelease
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case author
        case assets
    }
}

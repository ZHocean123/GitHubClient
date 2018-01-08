//
//  EventViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 01/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GitHubClient

struct EventViewModel {

    let event: Event

    var attributedString: NSMutableAttributedString?

    init(_ event: Event) {
        self.event = event
        buildViews()
    }

    mutating func buildViews() {

        let actor = event.actor
        let attributedString = NSMutableAttributedString(string: actor.login).addActorAttribut(URL(string: "user://\(actor.login)")!)

        switch event.payload {
        case .forkEvent(let forkEvent):
            let repo = event.repo
            let forkee = forkEvent.forkee
            attributedString.append(NSMutableAttributedString(string: " forked ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            attributedString.append(NSMutableAttributedString(string: " from ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: "\(forkee.owner.login)/\(forkee.name)").addRepoAttribut(URL(string: "repo://\(forkee.url)")!))
        case .watchEvent:
            let repo = event.repo
            attributedString.append(NSMutableAttributedString(string: " stared ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
        case .issueCommentEvent(let issueCommentEvent):
            let repo = event.repo
        case .issuesEvent(let issuesEvent):
            let repo = event.repo
        case .pushEvent(let pushEvent):
            let repo = event.repo
            attributedString.append(NSMutableAttributedString(string: " pushed to ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: pushEvent.ref).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            attributedString.append(NSMutableAttributedString(string: " in ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            for commit in pushEvent.commits {
                attributedString.append(NSMutableAttributedString(string: "\n").addSmallAttribut())
                attributedString.append(NSMutableAttributedString(string: String(commit.sha.prefix(6))).addCommitAttribut(URL(string: "commit://\(commit.url)")!))
                attributedString.append(NSMutableAttributedString(string: " - ").addSmallSepAttribut())
                attributedString.append(NSMutableAttributedString(string: commit.message).addSmallAttribut())
            }
        case .createEvent(let createEvent):
            let repo = event.repo
            switch createEvent.refType {
            case .repository:
                attributedString.append(NSMutableAttributedString(string: " created a repository ").addNormalAttribut())
                attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .branch:
                attributedString.append(NSMutableAttributedString(string: " created a branch ").addNormalAttribut())
                attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .tag:
                attributedString.append(NSMutableAttributedString(string: " created a tag ").addNormalAttribut())
                attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            }
        case .releaseEvent(let releaseEvent):
            let repo = event.repo
            attributedString.append(NSMutableAttributedString(string: " released ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: releaseEvent.release.tagName).addRepoAttribut(URL(string: "release://\(releaseEvent.release.url)")!))
            attributedString.append(NSMutableAttributedString(string: " at ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
        default:
            break
        }
        self.attributedString = attributedString
    }
}

extension NSAttributedStringKey {
    static let URLLinkKey = NSAttributedStringKey("URLLinkKey")
}
let semiboldFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
let regularFont = UIFont.systemFont(ofSize: 14, weight: .regular)
let smallregularFont = UIFont.systemFont(ofSize: 12, weight: .regular)
let commitColor = UIColor(hex: 0x586069)

extension NSMutableAttributedString {
    func addNormalAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: regularFont, .foregroundColor: UIColor.black],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addActorAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: semiboldFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addRepoAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: semiboldFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addBranchAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: regularFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addCommitAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: smallregularFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addSmallAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: smallregularFont, .foregroundColor: commitColor],
                           range: NSMakeRange(0, self.length))
        return self
    }
    
    func addSmallSepAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: smallregularFont, .foregroundColor: UIColor.gray],
                           range: NSMakeRange(0, self.length))
        return self
    }
}

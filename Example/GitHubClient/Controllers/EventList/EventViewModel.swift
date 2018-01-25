//
//  EventViewModel.swift
//  GitHubClient_Example
//
//  Created by yang on 01/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import GitHubClient
import UIKit
import YYText

struct EventViewModel {

    let event: Event

    var attributedString: NSMutableAttributedString?

    init(_ event: Event) {
        self.event = event
        buildViews()
    }

    mutating func buildViews() {

        let attributedString = NSMutableAttributedString()

        // actor
        let actor = event.actor
        let actorStr = NSMutableAttributedString(string: actor.login)
        actorStr.addLink { (_, _, _, _) in
            navigator.push("app://user/\(actor.login)")
        }
        attributedString.append(actorStr)

        switch event.payload {
        case .forkEvent(let forkEvent):
            let repo = event.repo
            let forkee = forkEvent.forkee
            attributedString
                .append(NSMutableAttributedString(string: " forked ").addNormalAttribut())
            attributedString
                .append(NSMutableAttributedString(string: repo.name)
                    .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            attributedString
                .append(NSMutableAttributedString(string: " from ").addNormalAttribut())
            attributedString
                .append(NSMutableAttributedString(string: "\(forkee.owner.login)/\(forkee.name)")
                    .addRepoAttribut(URL(string: "repo://\(forkee.url)")!))
        case .watchEvent:
            attributedString
                .append(NSMutableAttributedString(string: " stared ")
                    .addNormalAttribut())
            let repo = event.repo
            let repoStr = NSMutableAttributedString(string: repo.name)
            repoStr.addLink { (_, _, _, _) in
                navigator.push("app://repo/\(repo.name)")
            }
            attributedString.append(repoStr)
        case .issueCommentEvent(let issueCommentEvent):
            let repo = event.repo
        case .issuesEvent(let issuesEvent):
            let repo = event.repo
        case .pushEvent(let pushEvent):
            let repo = event.repo
            let branchName = String(pushEvent.ref.split(separator: "/").last ?? "")

            let components = [" pushed to ", branchName, " in ", repo.name]
                .map({ NSMutableAttributedString(string: $0) })
            components[0].addNormalAttribut()
            components[1].addBranchAttribut()
            components[1].addLink { (_, _, _, _) in
                navigator.push("app://repo/\(repo.name)")
            }
            components[2].addNormalAttribut()
            components[3].addLink { (_, _, _, _) in
                navigator.push("app://repo/\(repo.name)")
            }
            components.forEach({ attributedString.append($0) })

            attributedString.add(spacing: 4)
            for commit in pushEvent.commits {
                let components = [String(commit.sha.prefix(6)), " - ", commit.message, "\n"]
                    .map({ NSMutableAttributedString(string: $0) })
                components[0].addLink { (_, _, _, _) in
                    navigator.push("app://repo/\(repo.name)")
                }
                components[1].addSmallSepAttribut()
                components[2].addSmallAttribut()
                components[3].addSmallAttribut()
                components.forEach({ attributedString.append($0) })
            }
        case .createEvent(let createEvent):
            let repo = event.repo
            switch createEvent.refType {
            case .repository:
                attributedString
                    .append(NSMutableAttributedString(string: " created a repository ")
                        .addNormalAttribut())
                attributedString
                    .append(NSMutableAttributedString(string: repo.name)
                    .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .branch:
                attributedString
                    .append(NSMutableAttributedString(string: " created a branch ")
                        .addNormalAttribut())
                attributedString
                    .append(NSMutableAttributedString(string: repo.name)
                        .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .tag:
                attributedString
                    .append(NSMutableAttributedString(string: " created a tag ")
                        .addNormalAttribut())
                attributedString
                    .append(NSMutableAttributedString(string: repo.name)
                        .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            }
        case .releaseEvent(let releaseEvent):
            let repo = event.repo
            attributedString
                .append(NSMutableAttributedString(string: " released ")
                    .addNormalAttribut())
            attributedString
                .append(NSMutableAttributedString(string: releaseEvent.release.tagName)
                    .addRepoAttribut(URL(string: "release://\(releaseEvent.release.url)")!))
            attributedString
                .append(NSMutableAttributedString(string: " at ")
                    .addNormalAttribut())
            attributedString
                .append(NSMutableAttributedString(string: repo.name)
                    .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
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
        self.addAttributes([.font: regularFont, .foregroundColor: UIColor.white],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addActorAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: semiboldFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addRepoAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: semiboldFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addBranchAttribut() {
        guard string.isEmpty else {
            return
        }

        yy_color = UIColor(hex: 0xB4D6FE)

        let border = YYTextBorder(fill: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15), cornerRadius: 3)
        yy_setTextBorder(border, range: yy_rangeOfAll())
    }

    func addBranchAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: regularFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addCommitAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: smallregularFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addSmallAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: smallregularFont, .foregroundColor: commitColor],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addSmallSepAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: smallregularFont, .foregroundColor: UIColor.white],
                           range: NSRange(location: 0, length: self.length))
        return self
    }
}

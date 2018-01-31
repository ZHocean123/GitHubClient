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

let containerSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)

struct EventViewModel {

    let event: Event

    var attributedString: NSMutableAttributedString?
    var layout: YYTextLayout?
    var cellHeight: CGFloat = 0

    init(_ event: Event) {
        self.event = event
        buildViews()
    }

    mutating func buildViews() {

        let text = NSMutableAttributedString()

        // actor
        let actor = event.actor
        let actorStr = NSMutableAttributedString(string: actor.login)
        actorStr.addLink { (_, _, _, _) in
            navigator.push("app://user/\(actor.login)")
        }
        actorStr.yy_font = .semiboldFont
        text.append(actorStr)

        switch event.payload {
        case .forkEvent(let forkEvent):
            let repo = event.repo
            let forkee = forkEvent.forkee
            text
                .append(NSMutableAttributedString(string: " forked ")
                    .addNormalAttribut())
            text
                .append(NSMutableAttributedString(string: repo.name)
                    .addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            text
                .append(NSMutableAttributedString(string: " from ").addNormalAttribut())
            text
                .append(NSMutableAttributedString(string: "\(forkee.owner.login)/\(forkee.name)")
                    .addRepoAttribut(URL(string: "repo://\(forkee.url)")!))
        case .watchEvent:
            text
                .append(NSMutableAttributedString(string: " stared ")
                    .addNormalAttribut())
            let repo = event.repo
            let repoStr = NSMutableAttributedString(string: repo.name)
            repoStr.addLink { (_, _, _, _) in
                navigator.push("app://repo/\(repo.name)")
            }
            text.append(repoStr)
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
            components.forEach({ text.append($0) })

            text.add(spacing: 4)
            for commit in pushEvent.commits {
                let commitId = String(commit.sha.prefix(6))
                let components = [commitId, " - ", commit.message, "\n"]
                    .map({ NSMutableAttributedString(string: $0) })
                components[0].addLink { (_, _, _, _) in
                    navigator.push("app://repo/\(repo.name)")
                }
                components[1].addSmallSepAttribut()
                components[2].addSmallAttribut()
                components[3].addSmallAttribut()
                components.forEach({ text.append($0) })
            }
        case .createEvent(let createEvent):
            let repo = event.repo
            switch createEvent.refType {
            case .repository:
                text.append(" created a repository ".attributed.addNormalAttribut())
                text.append(repo.name.attributed.addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .branch:
                text.append(" created a branch ".attributed.addNormalAttribut())
                text.append(repo.name.attributed.addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            case .tag:
                text.append(" created a tag ".attributed.addNormalAttribut())
                text.append(repo.name.attributed.addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            }
        case .releaseEvent(let releaseEvent):
            let repo = event.repo
            text.append(" released ".attributed.addNormalAttribut())
            text.append(releaseEvent.release.tagName.attributed.addRepoAttribut(URL(string: "release://\(releaseEvent.release.url)")!))
            text.append(" at ".attributed.addNormalAttribut())
            text.append(repo.name.attributed.addRepoAttribut(URL(string: "repo://\(repo.url)")!))
        default:
            break
        }
        var size = containerSize
        size.width -= (48 + 8)
        self.attributedString = text
        let container = YYTextContainer(size: size)
        let textLayout = YYTextLayout(container: container, text: text)
        self.cellHeight = max((textLayout?.textBoundingSize.height ?? 0) + 38.5, 48)
        self.layout = textLayout
    }
}

extension NSAttributedStringKey {
    static let URLLinkKey = NSAttributedStringKey("URLLinkKey")
}

extension NSMutableAttributedString {
    func addNormalAttribut() -> NSMutableAttributedString {
        self.yy_font = .regularFont
        return self
    }

    func addRepoAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: UIFont.semiboldFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addBranchAttribut() {
        guard string.isEmpty else {
            return
        }

        yy_color = .linkColor

        let border = YYTextBorder(fill: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.15), cornerRadius: 3)
        yy_setTextBorder(border, range: yy_rangeOfAll())
    }

    func addBranchAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: UIFont.regularFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addCommitAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: UIFont.smallregularFont, .foregroundColor: UIColor.blue],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addSmallAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: UIFont.smallregularFont, .foregroundColor: UIColor.commitColor],
                           range: NSRange(location: 0, length: self.length))
        return self
    }

    func addSmallSepAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: UIFont.smallregularFont, .foregroundColor: UIColor.black],
                           range: NSRange(location: 0, length: self.length))
        return self
    }
}

extension String {
    var attributed: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.yy_color = .normalColor
        return attributedString
    }
}

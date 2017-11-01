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

            self.attributedString = attributedString
        case .watchEvent(let watchEvent):
            let repo = event.repo
            attributedString.append(NSMutableAttributedString(string: " stared ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))

            self.attributedString = attributedString
        case .issueCommentEvent(let issueCommentEvent):
            let repo = event.repo
            
            self.attributedString = attributedString
        case .pushEvent(let pushEvent):
            let repo = event.repo
            attributedString.append(NSMutableAttributedString(string: " pushed to ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: pushEvent.ref).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            attributedString.append(NSMutableAttributedString(string: " in ").addNormalAttribut())
            attributedString.append(NSMutableAttributedString(string: repo.name).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            for commit in pushEvent.commits {
                attributedString.append(NSMutableAttributedString(string: "\n"))
                attributedString.append(NSMutableAttributedString(string: commit.sha).addRepoAttribut(URL(string: "repo://\(repo.url)")!))
            }
            
            self.attributedString = attributedString
        case .createEvent(let createEvent):
            let repo = event.repo
            switch createEvent.refType {
            case .repository:
                print("\(actor.login) created a repository \(repo.name)")
            case .branch:
                break
            case .tag:
                break
            }

        default:
            break
        }
    }
}

extension NSAttributedStringKey {
    static let URLLinkKey = NSAttributedStringKey("URLLinkKey")
}
let actorFont = UIFont.systemFont(ofSize: 14, weight: .bold)

extension NSMutableAttributedString {
    func addNormalAttribut() -> NSMutableAttributedString {
        self.addAttributes([.font: actorFont, .foregroundColor: UIColor.black],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addActorAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: actorFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }

    func addRepoAttribut(_ link: URL) -> NSMutableAttributedString {
        self.addAttributes([.URLLinkKey: link, .font: actorFont, .foregroundColor: UIColor.blue],
                           range: NSMakeRange(0, self.length))
        return self
    }
}

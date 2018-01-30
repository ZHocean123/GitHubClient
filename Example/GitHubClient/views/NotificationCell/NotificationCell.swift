//
//  NotificationCell.swift
//  GitHubClient_Example
//
//  Created by yang on 02/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Reusable
import UIKit
import GitHubClient

class NotificationCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var markButton: UIButton!

    var notification: GitHubClient.Notification? {
        didSet {
            self.subjectLabel.text = notification?.subject.title
            self.dateLabel.text = notification?.updatedAt
            self.markButton.isHidden = !(notification?.unread ?? false)
            switch notification?.subject.type ?? "" {
            case "Issue":
                self.typeImageView.image = #imageLiteral(resourceName: "issue-opened")
            case "PullRequest":
                self.typeImageView.image = #imageLiteral(resourceName: "pull-request")
            case "Release":
                self.typeImageView.image = #imageLiteral(resourceName: "tag")
            default:
                self.typeImageView.image = nil
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

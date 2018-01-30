//
//  EventCell.swift
//  GitHubClient_Example
//
//  Created by yang on 27/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Reusable
import UIKit
import YYText
import Kingfisher

class EventCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var detailLabel: YYLabel!
    @IBOutlet private weak var dateLabel: UILabel!

    var layout: EventViewModel? {
        didSet {
            if let url = layout?.event.actor.avatarUrl {
                userImageView.kf.setImage(with: ImageResource(downloadURL: url))
            } else {
                userImageView.image = #imageLiteral(resourceName: "defaultAvatar")
            }
            dateLabel.text = layout?.event.type.rawValue
            detailLabel.textLayout = layout?.layout
//            detailLabel.attributedText = layout?.attributedString
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

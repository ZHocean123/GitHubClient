//
//  NotificationCell.swift
//  GitHubClient_Example
//
//  Created by yang on 02/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Reusable
import UIKit

class NotificationCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var subjectLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var markButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

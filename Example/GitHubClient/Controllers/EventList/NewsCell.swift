//
//  NewsCell.swift
//  GitHubClient_Example
//
//  Created by yang on 27/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import YYText

class EventCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var detailLabel: YYLabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        detailLabel.preferredMaxLayoutWidth = detailLabel.frame.width
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

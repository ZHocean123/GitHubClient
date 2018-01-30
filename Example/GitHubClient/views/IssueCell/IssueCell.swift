//
//  IssueCell.swift
//  GitHubClient_Example
//
//  Created by yang on 19/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reusable
import GitHubClient

class IssueCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var styleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var commontLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    var viewModel: Issue? {
        didSet {
            guard let viewModel = viewModel else {
                styleLabel.text = nil
                titleLabel.text = nil
                commontLabel.text = nil
                dateLabel.text = nil
                return
            }
            switch viewModel.state {
            case "open":
                styleLabel.textColor = UIColor.openColor
                styleLabel.text = "\u{e623}"
            case "":
                styleLabel.textColor = UIColor.closeColor
                styleLabel.text = "\u{e625}"
            case "":
                styleLabel.textColor = UIColor.openColor
                styleLabel.text = "\u{e896}"
            case "":
                styleLabel.textColor = UIColor.mergedColor
                styleLabel.text = "\u{e623}"
            default:
                break
            }
            titleLabel.text = "#\(viewModel.number) \(viewModel.title)"
            commontLabel.text = "\(viewModel.comments)"
            dateLabel.text = viewModel.createdAt
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleLabel.font = .issueStatusFont
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

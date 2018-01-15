//
//  RepositoryCell.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import DynamicColor
import GitHubClient
import Reusable
import SnapKit
import YYText

class RepositoryCell: UITableViewCell, NibReusable {

    // repo图标
    @IBOutlet weak var repoImageView: UIImageView!
    // repo名称
    @IBOutlet weak var repoNameLabel: YYLabel!
    // language
    @IBOutlet weak var languageLabel: UILabel!
    // stars
    @IBOutlet weak var starsLabel: UILabel!
    // forks
    @IBOutlet weak var forkLabel: UILabel!
    // 更新时间
    @IBOutlet weak var updateLabel: UILabel!
    // topics
    @IBOutlet weak var topicsView: TopicsView!

    var cellLayout: CellLayout? {
        didSet {
            repoImageView.image = #imageLiteral(resourceName: "repo")
            languageLabel.text = cellLayout?.item.language
            starsLabel.text = String(cellLayout?.item.stargazersCount ?? 0)
            forkLabel.text = String(cellLayout?.item.forksCount ?? 0)
            updateLabel.text = DateString(cellLayout?.item.updatedAt ?? "")?.agoDateStr
            topicsView.topics = cellLayout?.item.topics ?? []

            repoNameLabel.preferredMaxLayoutWidth = repoNameLabel.frame.width
            repoNameLabel.attributedText = cellLayout?.dispalyStr
        }
    }

    var item: Repository? {
        didSet {
            repoImageView.image = #imageLiteral(resourceName: "repo")
            languageLabel.text = item?.language
            starsLabel.text = String(item?.stargazersCount ?? 0)
            forkLabel.text = String(item?.forksCount ?? 0)
            updateLabel.text = DateString(item?.updatedAt ?? "")?.agoDateStr
            topicsView.topics = item?.topics ?? []

            let owner = NSMutableAttributedString(string: item?.owner.login ?? "")
            owner.addLink { [weak self] (_, _, _, _) in
                navigator.push("app://user", context: self?.item?.owner)
            }

            let repo = NSMutableAttributedString(string: item?.name ?? "")
            repo.addLink { [weak self] (_, _, _, _) in
                navigator.push("app://repo", context: self?.item)
            }

            let str = NSMutableAttributedString()
            str.append(owner)
            str.append(NSAttributedString(string: " / "))
            str.append(repo)
            str.yy_setFont(UIFont.systemFont(ofSize: 14), range: str.yy_rangeOfAll())

            if let description = item?.description {
                str.add(spacing: 4)
                let descriptionStr = NSMutableAttributedString(string: description)
                descriptionStr.yy_setColor(UIColor.gray, range: descriptionStr.yy_rangeOfAll())
                descriptionStr.yy_setFont(UIFont.systemFont(ofSize: 12), range: descriptionStr.yy_rangeOfAll())
                str.append(descriptionStr)
            }

            repoNameLabel.preferredMaxLayoutWidth = repoNameLabel.frame.width
            repoNameLabel.attributedText = str
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

struct CellLayout {
    var item: Repository
    var dispalyStr: NSAttributedString?
    static let topicLabel = TopicLabel()

    init(_ item: Repository) {
        self.item = item

        let owner = NSMutableAttributedString(string: item.owner.login)
        owner.addLink { (_, _, _, _) in
            navigator.push("app://user/\(item.owner.login)")
        }

        let repo = NSMutableAttributedString(string: item.name)
        repo.addLink { (_, _, _, _) in
            navigator.push("app://repo", context: item)
        }

        let str = NSMutableAttributedString()
        str.append(owner)
        str.append(NSAttributedString(string: " / "))
        str.append(repo)
        str.yy_setFont(UIFont.systemFont(ofSize: 14), range: str.yy_rangeOfAll())

        if let description = item.description {
            str.add(spacing: 4)
            let descriptionStr = NSMutableAttributedString(string: description)
            descriptionStr.yy_setColor(UIColor.gray, range: descriptionStr.yy_rangeOfAll())
            descriptionStr.yy_setFont(UIFont.systemFont(ofSize: 12), range: descriptionStr.yy_rangeOfAll())
            str.append(descriptionStr)
        }

        dispalyStr = str
    }
}

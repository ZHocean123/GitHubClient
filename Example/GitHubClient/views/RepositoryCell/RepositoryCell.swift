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

class RepositoryCell: UITableViewCell, NibReusable {

    // repo图标
    @IBOutlet weak var repoImageView: UIImageView!
    // repo名称
    @IBOutlet weak var repoNameLabel: UILabel!
    // repo描述
    @IBOutlet weak var descriptionLabel: UILabel!
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
            repoNameLabel.text = "\(cellLayout?.item.owner.login ?? "")/\(cellLayout?.item.name ?? "")"
            descriptionLabel.text = cellLayout?.item.description
            languageLabel.text = cellLayout?.item.language
            starsLabel.text = String(cellLayout?.item.stargazersCount ?? 0)
            forkLabel.text = String(cellLayout?.item.forksCount ?? 0)
            updateLabel.text = DateString(cellLayout?.item.updatedAt ?? "")?.agoDateStr
            topicsView.topics = cellLayout?.item.topics ?? []
            descriptionLabel.backgroundColor = UIColor.gray
            topicsView.backgroundColor = UIColor.gray

            setNeedsLayout()
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
//    var topicsFrames: [CGRect]
    var height: CGFloat

    static let cell: RepositoryCell = {
        let width = UIScreen.main.bounds.width
        let cell = UINib.init(nibName: "RepositoryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RepositoryCell

        cell.contentView.snp.makeConstraints({ (make) in
            make.edges.equalTo(cell)
            make.width.equalTo(width).priority(999)
        })
        return cell
    }()
    static let topicLabel = TopicLabel()

    init(_ item: Repository) {
        self.item = item

        // repoNameLabel
        CellLayout.cell.repoNameLabel.text = item.name

        // descriptionLabel
        CellLayout.cell.descriptionLabel.text = item.description

        CellLayout.cell.topicsView.topics = item.topics ?? []

        height = CellLayout.cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1 / UIScreen.main.scale
    }
}

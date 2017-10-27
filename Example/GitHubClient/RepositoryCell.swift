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

class RepositoryCell: UITableViewCell {

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
    let topicsContainer = UIView()

    var cellLayout: CellLayout? {
        didSet {
            repoImageView.image = #imageLiteral(resourceName: "repo")
            repoNameLabel.text = "\(cellLayout?.item.owner.login ?? "")/\(cellLayout?.item.name ?? "")"
            descriptionLabel.text = cellLayout?.item.description
            languageLabel.text = cellLayout?.item.language
            starsLabel.text = String(cellLayout?.item.stargazersCount ?? 0)
            forkLabel.text = String(cellLayout?.item.forksCount ?? 0)
            updateLabel.text = DateString(cellLayout?.item.updatedAt ?? "")?.agoDateStr
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

class TopicLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.systemFont(ofSize: 12)
        backgroundColor = UIColor(hex: 0xe7f3ff)
        textColor = UIColor(hex: 0x0366d6)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

struct CellLayout {
    var item: Repository
//    var topicsFrames: [CGRect]
    var height: CGFloat

    static let cell: RepositoryCell = {
        let width = UIScreen.main.bounds.width
        let cell = UINib.init(nibName: "RepositoryCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RepositoryCell
        cell.contentView.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width))
        return cell
    }()
    static let topicLabel = TopicLabel()

    init(_ item: Repository) {
        self.item = item

        // repoNameLabel
        CellLayout.cell.repoNameLabel.text = item.name

        // descriptionLabel
        CellLayout.cell.descriptionLabel.text = item.description

        height = CellLayout.cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
    }
}

//
//  IssueCommontCell.swift
//  GitHubClient_Example
//
//  Created by yang on 01/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import EFMarkdown
import GitHubClient
import Reusable
import UIKit

class IssueCommontCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var htmlView: ReadMeView!

    var number: Int = -1
    var viewModel: IssueCommontCellViewModel? {
        didSet {
            htmlView.delegate = viewModel
            htmlView.webView.loadHTMLString(viewModel?.commont ?? "",
                                            baseURL: IssueCommontCellViewModel.issueCommontTemplateURL)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        htmlView.webView.stopLoading()
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

class IssueCommontCellViewModel {
    static let issueCommontTemplateURL = Bundle.main.url(forResource: "comment", withExtension: "html")!
    static let templateContent = try? String(contentsOf: IssueCommontCellViewModel.issueCommontTemplateURL,
                                             encoding: String.Encoding.utf8)
    var commont: String = ""
    var htmlHeight: CGFloat = 10

    var heightChangeHandler: ((CGFloat) -> Void)?

    init(_ commont: IssueComment) {
        do {
            let markdownHTML = try EFMarkdown().markdownToHTML(commont.body)
            self.commont = IssueCommontCellViewModel.templateContent?
                .replacingOccurrences(of: "$PLACEHOLDER", with: markdownHTML) ?? ""
        } catch let error {
            log.error(error)
        }
    }
}

extension IssueCommontCellViewModel: ReadMeViewDelegate {
    func heightDidChange(_ height: CGFloat) {
        if height != htmlHeight {
             heightChangeHandler?(height)
        }
    }
}

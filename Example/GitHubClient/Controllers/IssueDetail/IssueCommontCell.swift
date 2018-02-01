//
//  IssueCommontCell.swift
//  GitHubClient_Example
//
//  Created by yang on 01/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reusable
import GitHubClient
import EFMarkdown

class IssueCommontCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var htmlView: ReadMeView!

    var viewModel: IssueCommontCellViewModel? {
        didSet {
            do {
                let templateURL = Bundle.main.url(forResource: "index", withExtension: "html")!
                let templateContent = try String(contentsOf: templateURL, encoding: String.Encoding.utf8)
                let htmlStr = templateContent.replacingOccurrences(of: "$PLACEHOLDER", with: viewModel?.commont ?? "")
                htmlView.webView.loadHTMLString(htmlStr, baseURL: templateURL)
            } catch {
                htmlView.webView.stopLoading()
            }
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

    var commont: String = ""

    init(_ commont: IssueComment) {
        do {
            self.commont = try EFMarkdown().markdownToHTML(commont.body)
        } catch let error {
            log.error(error)
        }
    }
}

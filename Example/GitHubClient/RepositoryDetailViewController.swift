//
//  RepositoryDetailViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 03/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GitHubClient
import SnapKit
import Reusable
import EFMarkdown

class RepositoryDetailViewController: UIViewController, StoryboardBased {

    var repository: Repository? {
        didSet {
            loadRepository()
        }
    }

    // MARK: - subviews
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var avatar: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var topicsView: TopicsView?
    @IBOutlet weak var starBtn: UIButton?
    @IBOutlet weak var issueBtn: UIButton?
    @IBOutlet weak var forkBtn: UIButton?
    @IBOutlet weak var languageLabel: UILabel?
    @IBOutlet weak var readMeView: ReadMeView?

    func setupSubviews() {

    }

    func setupConstraints() {

    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        loadRepository()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadRepository() {
        titleLabel?.text = repository?.name
        descriptionLabel?.text = repository?.description
        topicsView?.topics = repository?.topics ?? []
        languageLabel?.text = repository?.language
        readMeView?.loadReadMe(url: repository?.readMeUrlStr)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

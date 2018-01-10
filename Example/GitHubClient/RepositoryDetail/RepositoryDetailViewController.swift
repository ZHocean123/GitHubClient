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
import RxSwift
import RxCocoa

class RepositoryDetailViewController: UIViewController, StoryboardBased {

    var repository: Repository? {
        didSet {
            loadRepository()
        }
    }
    var viewModel: RepositoryDetailViewModel?

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
    @IBOutlet weak var languagesBar: LanguageBar?

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

    var disposeBag = DisposeBag()

    func loadRepository() {

        if let repository = repository {
            viewModel = RepositoryDetailViewModel(repository)
            viewModel?.languagesObserver.subscribe(onNext: { [weak self] (languages) in
                self?.languagesBar?.languages = languages
            }).disposed(by: disposeBag)
            viewModel?.topicsObserver.subscribe(onNext: { [weak self] (topics) in
                print(topics)
                self?.topicsView?.topics = topics
            }).disposed(by: disposeBag)
        }

        viewModel?.loadRepoTopics()

        titleLabel?.text = repository?.name
        descriptionLabel?.text = repository?.description
//        topicsView?.topics = repository?.topics ?? []
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

extension Repository {
    func getLanguages(success: Github.SuccessHandler<[String: Int]>?,
                      failure: Github.FailureHandler?) -> URLSessionTask {
        return Github.shared.languages(owner: owner.login, repo: name, success: success, failure: failure)
    }
}

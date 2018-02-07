//
//  RepositoryDetailViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 03/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import EFMarkdown
import GitHubClient
import Reusable
import RxSwift
import SnapKit
import UIKit

class RepositoryDetailViewController: BaseViewController, StoryboardBased {

    var repository: Repository? {
        set {
            viewModel.repo = newValue
        }
        get {
            return viewModel.repo
        }
    }

    let viewModel = RepositoryDetailViewModel()

    // MARK: - subviews
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var avatar: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var topicsView: TopicsView!
    @IBOutlet private weak var starBtn: ControlButton!
    @IBOutlet private weak var issueBtn: ControlButton!
    @IBOutlet private weak var forkBtn: ControlButton!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var readMeView: ReadMeView!
    @IBOutlet private weak var languagesBar: LanguageBar!

    func setupSubviews() {
        descriptionLabel.superview?.isHidden = true
        languageLabel.superview?.isHidden = true
        topicsView.superview?.isHidden = true
    }

    func setupConstraints() {

    }

    func bindViewModel() {
        viewModel.repository.asObservable().subscribe(onNext: { [weak self] repository in
            self?.titleLabel.text = repository?.name
            self?.descriptionLabel.text = repository?.description
            self?.languageLabel.text = repository?.language
            self?.readMeView.loadReadMe(url: repository?.readMeUrlStr)
            self?.starBtn.countNum = repository?.stargazersCount ?? 0
            self?.forkBtn.countNum = repository?.forks ?? 0
            self?.issueBtn.countNum = repository?.openIssuesCount ?? 0
            UIView.animate(withDuration: 0.3, animations: {
                self?.descriptionLabel.superview?.isHidden = repository?.description == nil
                self?.languageLabel.superview?.isHidden = repository?.language == nil
            })
        }).disposed(by: disposeBag)
        viewModel.languages.asObservable().subscribe(onNext: { [weak self] languages in
            self?.languagesBar.languages = languages
            self?.languagesBar.isHidden = languages.isEmpty
            if languages.isEmpty {
                self?.languagesBar.isHidden = true
            } else {
                self?.languagesBar.isHidden = false
                let frame = self?.languagesBar.frame ?? .zero
                self?.languagesBar.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: 0, height: frame.height)
                self?.languagesBar.clipsToBounds = true
                UIView.animate(withDuration: 0.3, animations: {
                    self?.languagesBar.frame = frame
                })
            }
        }).disposed(by: disposeBag)
        viewModel.topics.asObservable().subscribe(onNext: { [weak self] topics in
            self?.topicsView.topics = topics
            if self?.topicsView.superview?.isHidden != topics.isEmpty {
                UIView.animate(withDuration: 0.3, animations: {
                    self?.topicsView.superview?.isHidden = topics.isEmpty
                })
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()

        bindViewModel()
        viewModel.loadRepoDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var disposeBag = DisposeBag()

    @IBAction func onBtnIssues(_ sender: Any) {
        guard let repository = repository else {
            return
        }
        navigator.push("app://repo/\(repository.owner.login)/\(repository.name)/issues")
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

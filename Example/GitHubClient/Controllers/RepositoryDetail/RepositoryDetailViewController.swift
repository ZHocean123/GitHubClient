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

class RepositoryDetailViewController: UIViewController, StoryboardBased {

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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topicsView: TopicsView!
    @IBOutlet weak var starBtn: ControlButton!
    @IBOutlet weak var issueBtn: ControlButton!
    @IBOutlet weak var forkBtn: ControlButton!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var readMeView: ReadMeView!
    @IBOutlet weak var languagesBar: LanguageBar!

    func setupSubviews() {
        descriptionLabel.superview?.isHidden = true
        languageLabel.superview?.isHidden = true
        topicsView.superview?.isHidden = true
    }

    func setupConstraints() {

    }

    func bindViewModel() {
        viewModel.repository.asObservable().subscribe(onNext: { [weak self] (repository) in
            self?.titleLabel.text = repository?.name
            self?.descriptionLabel.text = repository?.description
            self?.descriptionLabel.superview?.isHidden = repository?.description == nil
            self?.languageLabel.text = repository?.language
            self?.languageLabel.superview?.isHidden = repository?.language == nil
            self?.readMeView.loadReadMe(url: repository?.readMeUrlStr)
            self?.starBtn.count = repository?.stargazersCount ?? 0
            self?.forkBtn.count = repository?.forks ?? 0
            self?.issueBtn.count = repository?.openIssuesCount ?? 0
            UIView.animate(withDuration: 0.25, animations: {
                self?.languageLabel.superview?.superview?.layoutIfNeeded()
            })
        }).disposed(by: disposeBag)
        viewModel.languages.asObservable().subscribe(onNext: { [weak self] (languages) in
            self?.languagesBar.languages = languages
            self?.languagesBar.isHidden = languages.count == 0
            UIView.animate(withDuration: 0.25, animations: {
                self?.languagesBar.superview?.layoutIfNeeded()
            })
        }).disposed(by: disposeBag)
        viewModel.topics.asObservable().subscribe(onNext: { [weak self] (topics) in
            self?.topicsView.topics = topics
            self?.topicsView.superview?.isHidden = topics.count == 0
            UIView.animate(withDuration: 0.25, animations: {
                self?.languageLabel.superview?.superview?.layoutIfNeeded()
            })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

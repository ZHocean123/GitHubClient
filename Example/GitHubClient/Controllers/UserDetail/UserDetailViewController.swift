//
//  UserDetailViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 15/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Kingfisher
import Reusable
import RxSwift
import UIKit

class UserDetailViewController: UIViewController, StoryboardBased {
    let viewModel = UserDetailViewModel()

    let disposeBag = DisposeBag()
    @IBOutlet private weak var avatarView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var followersBtn: ControlButton!
    @IBOutlet private weak var followingBtn: ControlButton!
    @IBOutlet private weak var reposBtn: ControlButton!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var blogLabel: UILabel!

    func bindViewModel() {
        viewModel.userVariable.asObservable().subscribe(onNext: { [weak self] user in
            if let url = user?.avatarUrl {
                self?.avatarView.kf.setImage(with: ImageResource(downloadURL: url), placeholder: #imageLiteral(resourceName: "defaultAvatar"))
            }
            self?.nameLabel.text = user?.login
            self?.fullNameLabel.text = user?.name
            self?.followersBtn.countNum = user?.followers ?? 0
            self?.followingBtn.countNum = user?.following ?? 0
            self?.reposBtn.countNum = user?.publicRepos ?? 0
            self?.companyLabel.text = user?.company
            self?.locationLabel.text = user?.location
            self?.emailLabel.text = user?.email
            self?.blogLabel.text = user?.blog

            self?.companyLabel.superview!.isHidden = user?.company?.isEmpty ?? true
            self?.locationLabel.superview!.isHidden = user?.location?.isEmpty ?? true
            self?.emailLabel.superview!.isHidden = user?.email?.isEmpty ?? true
            self?.blogLabel.superview!.isHidden = user?.blog?.isEmpty ?? true
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBtnRepos(_ sender: ControlButton) {
        guard sender.countNum > 0, let loginName = viewModel.loginName else {
            return
        }
        navigator.push("app://users/\(loginName)/repos")
    }
}

//
//  UserRepositoryViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 05/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import Reusable
import GitHubClient
import RxSwift
import UITableView_FDTemplateLayoutCell
import URLNavigator

class RepositoryListViewController: UIViewController, StoryboardBased {

    var viewModel = RepositoryListViewModel()

    let disposeBag = DisposeBag()

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableview: UITableView!
    lazy var filterMenu: FilterMenu = {
        let menu = FilterMenu()
        menu.options = ["all","public","private"]
        return menu
    }()
    func bindViewModel() {
        viewModel.loadingVariable.asObservable().subscribe(onNext: { [weak self] (state) in
            switch state {
            case .loading:
                self?.showProcess()
            case .loaded:
                self?.hideAllHUD()
                self?.tableview.reloadData()
            case .error(let error):
                self?.showError(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.register(cellType: RepositoryCell.self)
        bindViewModel()

        switch viewModel.sourceType {
        case .none:
            viewModel.sourceType = .owner
        default:
            break
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-mail_filter"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBtnFilter))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onChangeRepositoryType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.repositoryType = .all
        case 1:
            viewModel.repositoryType = .public
        case 2:
            viewModel.repositoryType = .private
        case 3:
            viewModel.repositoryType = .owner
        case 4:
            viewModel.repositoryType = .member
        default:
            return
        }
    }
}

@objc extension RepositoryListViewController {
    func onBtnFilter() {
        if filterMenu.isShow {
            filterMenu.hide()
        } else {
            filterMenu.show(toView: view)
        }
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.layouts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RepositoryCell.self)
        cell.cellLayout = viewModel.layouts[indexPath.row]
        return cell
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: RepositoryCell.reuseIdentifier, cacheBy: indexPath, configuration: { (cell) in
            (cell as? RepositoryCell)?.cellLayout = self.viewModel.layouts[indexPath.row]
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.push("app://repo", context: viewModel.repositories[indexPath.row])
    }
}

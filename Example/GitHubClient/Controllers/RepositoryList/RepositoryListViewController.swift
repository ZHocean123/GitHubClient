//
//  UserRepositoryViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 05/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import GitHubClient
import Reusable
import RxSwift
import UIKit
import UITableView_FDTemplateLayoutCell
import URLNavigator

class RepositoryListViewController: UIViewController, StoryboardBased {

    var viewModel = RepositoryListViewModel()

    let disposeBag = DisposeBag()

    @IBOutlet private weak var dropDownMenu: DropDownMenu!
    @IBOutlet private weak var tableview: UITableView!

    func bindViewModel() {
        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] state in
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

        viewModel.repositoryTypes.asObservable().subscribe(onNext: { [weak self] types in
            self?.dropDownMenu.options = types
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.register(cellType: RepositoryCell.self)
        var temp = tableview.contentInset
        temp.top += 30
        tableview.contentInset = temp
        bindViewModel()

        dropDownMenu.delegate = self

        switch viewModel.sourceType {
        case .none:
            viewModel.sourceType = .owner
        default:
            break
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icons8-mail_filter"),
                                                            style: UIBarButtonItemStyle.plain,
                                                            target: self,
                                                            action: #selector(onBtnFilter))
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
    @IBAction func onBtnType(_ sender: Any) {
        if dropDownMenu.isShowing {
            dropDownMenu.hideMenu()
        } else {
            dropDownMenu.showOptionSelect(viewModel.repositoryTypes.value,
                                          selectedOption: viewModel.repositoryType)
        }
    }
    @IBAction func onBtnSortType(_ sender: Any) {
        dropDownMenu.hideMenu()
    }
}

@objc extension RepositoryListViewController {
    func onBtnFilter() {
        dropDownMenu.showMenu()
    }
}

extension RepositoryListViewController: OptionMenuDelegate {
    func didSelect(option: MenuOption) {
        dropDownMenu.hideMenu()
        viewModel.repositoryType = option as? RepositoryType ?? .all
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.layoutList.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RepositoryCell.self)
        cell.cellLayout = viewModel.layoutList.value[indexPath.row]
        return cell
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: RepositoryCell.reuseIdentifier,
                                          cacheBy: indexPath, configuration: { cell in
                                              (cell as? RepositoryCell)?.cellLayout = self.viewModel.layoutList.value[indexPath.row]
                                          })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.push("app://repo", context: viewModel.repositories[indexPath.row])
    }
}

//
//  RepositorySearchViewController.swift
//  MyGithub
//
//  Created by yang on 13/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import GitHubClient
import Reusable
import RxSwift
import UIKit
import UITableView_FDTemplateLayoutCell

class RepositorySearchViewController: BaseViewController, StoryboardBased, ViewModelBased {

    var viewModel = RepositorySearchViewModel()

    @IBOutlet private weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.register(cellType: RepositoryCell.self)
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
    var disposeBag: DisposeBag?
}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
        let disposeBag = DisposeBag()
        guard let key = searchBar.text else {
            return
        }
        viewModel.pagination.page += 1
        showProcess()
        viewModel.search(key: key).subscribe { [weak self] event in
            switch event {
            case .next:
                self?.hideAllHUD()
                self?.tableview.reloadData()
            case .error(let error):
                self?.showError(error.localizedDescription)
            default:
                break
            }
        }.disposed(by: disposeBag)
        self.disposeBag = disposeBag

        //        Github.shared.search(repo: key, success: { [weak self] (result) in
//            self?.repositories = result.items
//            self?.layouts = result.items.map({ (item) -> CellLayout in
//                return CellLayout(item)
//            })
//            self?.hideAllHUD()
//            self?.tableview.reloadData()
//        }, failure: { [weak self] (error) in
//            self?.showError(error.localizedDescription)
//        })
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RepositoryCell.self)
        cell.cellLayout = viewModel.layouts[indexPath.row]
        return cell
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: RepositoryCell.reuseIdentifier,
                                          cacheBy: indexPath, configuration: { cell in
            (cell as? RepositoryCell)?.cellLayout = self.viewModel.layouts[indexPath.row]
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.push("app://repo", context: viewModel.repositories[indexPath.row])
    }
}

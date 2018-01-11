//
//  RepositorySearchViewController.swift
//  MyGithub
//
//  Created by yang on 13/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell
import GitHubClient
import Reusable
import RxSwift

class RepositorySearchViewController: UIViewController, StoryboardBased, ViewModelBased {

    var viewModel = RepositorySearchViewModel()

    @IBOutlet weak var tableview: UITableView!

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
        return viewModel.layouts[indexPath.row].height
        /*
        let item = repositories[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: "searchResultCell", cacheBy: indexPath, configuration: { (cell) in
            let cell = cell as! RepositoryCell
            cell.repoNameLabel.text = item.name
            cell.descriptionLabel.text = item.description
        })
         */
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.viewModel.pick(repository: self.viewModel.repositories[indexPath.row])
        let controller = RepositoryDetailViewController.instantiate()
        controller.repository = self.viewModel.repositories[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

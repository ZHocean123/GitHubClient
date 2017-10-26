//
//  RepositorySearchViewController.swift
//  MyGithub
//
//  Created by yang on 13/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell

class RepositorySearchViewController: UIViewController {

    var pagination = Pagination()
    @IBOutlet weak var tableview: UITableView!
    var disposeBag = DisposeBag()
    var repositories = [Repository]()
    var layouts = [CellLayout]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableview.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "searchResultCell")
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

}

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let key = searchBar.text else {
            return
        }
        pagination.page += 1
        disposeBag = DisposeBag()
        showProcess()
        SearchPrvider.rx.request(.repositories(q: key,
                                               sort: .stars,
                                               order: .desc,
                                               pagination: pagination))
            .mapObject(SearchRepositoryResult.self)
            .subscribe { [weak self] (event) in
                switch event {
                case .success(let result):
                    self?.repositories = result.items
                    self?.layouts = result.items.map({ (item) -> CellLayout in
                        return CellLayout(item)
                    })
                    self?.hideAllHUD()
                    self?.tableview.reloadData()
                case .error(let error):
                    self?.showError(error.errorMessage)
                    print(error.errorMessage)
                }
            }.disposed(by: disposeBag)
    }
}

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! RepositoryCell
        cell.cellLayout = layouts[indexPath.row]
        return cell
    }
}

extension RepositorySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return layouts[indexPath.row].height
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
        let controller = RepositoryViewController()
        controller.repository = repositories[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

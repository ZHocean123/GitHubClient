//
//  EventsViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 30/10/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GitHubClient
import Kingfisher
import CFNotify
import UITableView_FDTemplateLayoutCell
import Reusable
import RxSwift
import MJRefresh

class EventListViewController: UIViewController {

    var viewModel = EventListViewModel()

    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!

    func bindViewModel() {
        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] (state) in
            switch state {
            case .loading:
                self?.showProcess()
            case .loaded:
                self?.hideAllHUD()
                self?.tableView.reloadData()
                self?.tableView.mj_header.endRefreshing()
            case .error(let error):
                self?.showError(error.localizedDescription)
                self?.tableView.mj_header.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(cellType: EventCell.self)
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            self?.viewModel.loadEvents()
        })
        bindViewModel()
        viewModel.loadEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

extension EventListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.layoutList.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EventCell.self)
        let layout = viewModel.layoutList.value[indexPath.row]
        cell.userImageView.kf.setImage(with: ImageResource(downloadURL: layout.event.actor.avatarUrl))
        cell.dateLabel.text = layout.event.type.rawValue
        cell.detailLabel.attributedText = layout.attributedString
        return cell
    }
}

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: EventCell.reuseIdentifier, cacheBy: indexPath, configuration: { (cell) in
            let cell = cell as! EventCell
            cell.detailLabel.attributedText = self.viewModel.layoutList.value[indexPath.row].attributedString
        })
    }
}


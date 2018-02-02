//
//  IssueDetailViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 18/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Reusable
import RxSwift
import UIKit

class IssueDetailViewController: UIViewController, StoryboardBased {

    let viewModel = IssueDetailViewModel()

    @IBOutlet private weak var tableView: UITableView!

    private let disposeBag = DisposeBag()

    func bindViewModel() {
//        viewModel.loadingState.asObservable().subscribe(onNext: { [weak self] state in
//            switch state {
//            case .loading:
//                self?.showProcess()
//            case .loaded:
//                self?.hideAllHUD()
//                self?.tableview.reloadData()
//            case .error(let error):
//                self?.showError(error.localizedDescription)
//            }
//        }).disposed(by: disposeBag)

        viewModel.comments.asObservable().subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(cellType: IssueCommontCell.self)
        tableView.separatorStyle = .none
        viewModel.loadComments()
        bindViewModel()
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

extension IssueDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard let cell = cell as? IssueCommontCell,
//            let cellViewModel = cell.viewModel else {
//                return
//        }
//        cellViewModel.heightChangeHandler = { [weak self] height in
//            guard let indexPathsForVisibleRows = self?.tableView.indexPathsForVisibleRows,
//                indexPathsForVisibleRows.contains(indexPath),
//                height + 86 != self?.cellHeights[indexPath.row] else {
//                    return
//            }
//            self?.cellHeights[indexPath.row] = height + 86
//            self?.tableView.beginUpdates()
//            self?.tableView.endUpdates()
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: IssueCommontCell.self)
        cell.viewModel = nil
        let cellViewModel = viewModel.comments.value[indexPath.row]
        cellViewModel.heightChangeHandler = nil
        cellViewModel.heightChangeHandler = { [weak self] height in
            guard cell.number == indexPath.row,
                let indexPathsForVisibleRows = self?.tableView.indexPathsForVisibleRows,
                indexPathsForVisibleRows.contains(indexPath),
                height != cellViewModel.htmlHeight else {
                    return
            }
            cellViewModel.htmlHeight = height
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
//            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
//                self?.tableView.beginUpdates()
//                self?.tableView.endUpdates()
//            }, completion: nil)
        }
        cell.viewModel = cellViewModel
        cell.number = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.value.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.comments.value[indexPath.row].htmlHeight + 86
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.comments.value[indexPath.row].htmlHeight = 200
//        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
//            self.tableView.beginUpdates()
//            //                self?.tableView.reloadRows(at: [indexPath], with: .none)
//            self.tableView.endUpdates()
//        }, completion: nil)
    }
}

//
//  NotificationsViewController.swift
//  GitHubClient_Example
//
//  Created by yang on 02/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import GitHubClient
import CFNotify

class NotificationsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notifications = [GitHubClient.Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNotifications()
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

    func loadNotifications() {
        Github.shared.notifications(success: { [weak self] (result) in
            DispatchQueue.global(qos: .utility).async {
//                let models = result.filter({ (event) -> Bool in
//                    switch event.type {
//                    case .issuesEvent, .issueCommentEvent:
//                        return false
//                    default:
//                        return true
//                    }
//                }).map({ EventViewModel($0) })
                DispatchQueue.main.async {
                    self?.notifications = result
//                    self?.models = models
                    self?.tableView.reloadData()
                }
            }
        }) { (error) in
            log.error(error)

            // config
            var classicViewConfig = CFNotify.Config()
            classicViewConfig.initPosition = .top(.center)
            classicViewConfig.appearPosition = .top
            classicViewConfig.hideTime = .never

            // view
            let cyberView = CFNotifyView.cyberWith(title: "Error",
                                                   body: error.localizedDescription,
                                                   theme: .fail(.light))

            CFNotify.present(config: classicViewConfig, view: cyberView, tapHandler: nil)
        }
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.subjectLabel.text = notifications[indexPath.row].subject.title
        cell.dateLabel.text = notifications[indexPath.row].updatedAt
        cell.markButton.isHidden = !notifications[indexPath.row].unread
        switch notifications[indexPath.row].subject.type {
        case "Issue":
            cell.typeImageView.image = #imageLiteral(resourceName: "issue-opened")
        case "PullRequest":
            cell.typeImageView.image = #imageLiteral(resourceName: "pull-request")
        case "Release":
            cell.typeImageView.image = #imageLiteral(resourceName: "tag")
        default:
            cell.typeImageView.image = nil
        }
        return cell
    }
}

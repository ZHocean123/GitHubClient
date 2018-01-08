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

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var models = [EventViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadEvents()
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

    func loadEvents() {
        Github.shared.events("ZHocean123", success: { [weak self] (result) in
            DispatchQueue.global(qos: .utility).async {
                let models = result.filter({ (event) -> Bool in
                    switch event.type {
                    case .issuesEvent,.issueCommentEvent:
                        return false
                    default:
                        return true
                    }
                }).map({ EventViewModel($0) })
                DispatchQueue.main.async {
                    self?.models = models
                    self?.tableView.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            
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

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.userImageView.kf.setImage(with: ImageResource(downloadURL: models[indexPath.row].event.actor.avatarUrl))
        cell.dateLabel.text = models[indexPath.row].event.type.rawValue
        cell.detailLabel.attributedText = models[indexPath.row].attributedString
        return cell
    }
}

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

class EventsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var events = [Event]()
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
            print(result)
            self?.events = result
            self?.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        cell.userImageView.kf.setImage(with: ImageResource(downloadURL: events[indexPath.row].actor.avatarUrl))
        cell.dateLabel.text = events[indexPath.row].type.rawValue
        return cell
    }
}

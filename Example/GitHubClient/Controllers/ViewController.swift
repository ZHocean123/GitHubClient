//
//  ViewController.swift
//  GitHubClient
//
//  Created by ZHocean123 on 10/26/2017.
//  Copyright (c) 2017 ZHocean123. All rights reserved.
//

import UIKit
import GitHubClient

class ViewController: UIViewController {

    @IBOutlet weak var logSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logSwitch.isOn = Github.showLog
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleLog(_ sender: UISwitch) {
        Github.showLog = sender.isOn
    }

    @IBAction func onBtnLogin(_ sender: Any) {
        Github.shared.login(navController: self.navigationController!, success: nil, failure: nil)
    }
}


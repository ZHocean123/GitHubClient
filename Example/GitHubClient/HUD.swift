//
//  HUD.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import MBProgressHUD
import UIKit

extension UIViewController {
    func showProcess() {
        let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.isUserInteractionEnabled = true
    }

    func showMessage(_ message: String, autoHide: Bool = true) {
        let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.isUserInteractionEnabled = false
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 2)
    }

    func showError(_ message: String, autoHide: Bool = true) {
        let hud = MBProgressHUD(for: view) ?? MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.isUserInteractionEnabled = false
        hud.label.text = message
        hud.hide(animated: true, afterDelay: 2)
    }

    func hideAllHUD() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

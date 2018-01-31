//
//  BorderView.swift
//  GitHubClient_Example
//
//  Created by yang on 12/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
public class BorderView: UIView {
    @IBInspectable var backgroundImage: UIImage? {
        didSet {
            if let image = backgroundImage {
                layer.backgroundColor = UIColor(patternImage: image).cgColor
            } else {
                layer.backgroundColor = nil
            }
        }
    }
}

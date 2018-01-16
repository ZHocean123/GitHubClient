//
//  FilterMenu.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 16/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class FilterMenu: UIView {
    
    var options: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedOption: String?
    var isShow: Bool = false

    func show(_ animated: Bool = true, toView view: UIView) {
        view.addSubview(self)
        isShow = true
        if animated {
            backgroundView.alpha = 0
            tableView.transform = CGAffineTransform(translationX: 0, y: -CGFloat(min(options.count, 3)) * 44)
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.transform = CGAffineTransform.identity
                self.backgroundView.alpha = 1
            })
        }
    }
    
    func hide(_ animated: Bool = true) {
        isShow = false
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.transform = CGAffineTransform(translationX: 0, y: -self.tableView.frame.height)
            }, completion: { (stop) in
                self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }

    private let backgroundView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(backgroundView)
        backgroundView.addSubview(tableView)

        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame = superview?.bounds ?? .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        var tempFrame = bounds
        tempFrame.size.height = CGFloat(min(options.count, 3)) * 44
        tableView.frame = tempFrame
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension FilterMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        return cell
    }
}

class OptionCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

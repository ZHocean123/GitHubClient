//
//  FilterMenu.swift
//  GitHubClient_Example
//
//  Created by ocean zhang on 16/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol MenuOption {
    var title: String { get }
}

protocol OptionMenuDelegate: class {
    func didSelect(option: MenuOption)
}

class OptionMenu: UIView {
    var options: [MenuOption] = [] {
        didSet {
            tableView.reloadData()
            setSelectedOption(selectedOption)
        }
    }
    var selectedOption: MenuOption? {
        didSet {
            setSelectedOption(selectedOption)
        }
    }

    var optionHeight: CGFloat = 30 {
        didSet {
            tableView.rowHeight = optionHeight
            backgroundView.setNeedsLayout()
            backgroundView.layoutIfNeeded()
        }
    }

    var isShow: Bool = false
    weak var delegate: OptionMenuDelegate?

    func show(_ animated: Bool = true, toView view: UIView) {
        view.addSubview(self)
        isShow = true
        if animated {
            backgroundView.alpha = 0
            tableView.transform = CGAffineTransform(translationX: 0,
                                                    y: -min(CGFloat(options.count) * optionHeight, bounds.height))
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.transform = CGAffineTransform.identity
                self.backgroundView.alpha = 1
            })
        }
    }

    private func setSelectedOption(_ option: MenuOption?, animated: Bool = true) {
        if let selectedOption = option, let index = options.index(where: { selectedOption.title == $0.title }) {
            tableView.selectRow(at: IndexPath(row: 0, section: index),
                                animated: animated, scrollPosition: UITableViewScrollPosition.top)
        } else {
            tableView.indexPathsForSelectedRows?.forEach({ tableView.deselectRow(at: $0, animated: animated) })
        }
    }

    func show(_ animated: Bool = true, toController viewController: UIViewController) {
        translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(self)
        if #available(iOS 11.0, *) {
            self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            self.topAnchor.constraint(equalTo: viewController.topLayoutGuide.bottomAnchor).isActive = true
            self.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
            self.bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor).isActive = true
            self.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        }

        isShow = true
        if animated {
            backgroundView.alpha = 0
            tableView.transform = CGAffineTransform(translationX: 0,
                                                    y: -min(CGFloat(options.count) * 44, bounds.height))
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
                self.backgroundView.alpha = 0
            }, completion: { finished in
                if finished {
                    self.removeFromSuperview()
                }
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

        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        tableView.bounces = false
        tableView.rowHeight = optionHeight

        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        frame = superview?.bounds ?? .zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        var tempFrame = bounds
        if #available(iOS 11.0, *) {
            tempFrame.origin.x = self.safeAreaInsets.left
            tempFrame.size.width -= (self.safeAreaInsets.left + self.safeAreaInsets.right)
        }
        tempFrame.size.height = min(CGFloat(options.count) * optionHeight, bounds.height)
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

extension OptionMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedOption = options[indexPath.row]
        delegate?.didSelect(option: options[indexPath.row])
    }
}

class OptionCell: UITableViewCell {
    let checkImage = UIImageView(image: #imageLiteral(resourceName: "icons8-checked"))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkImage)
        checkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        checkImage.isHidden = !isSelected
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImage.isHidden = !selected
        textLabel?.textColor = selected ? UIColor.red : UIColor.gray
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

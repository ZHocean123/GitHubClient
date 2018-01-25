//
//  DropDownMenu.swift
//  GitHubClient_Example
//
//  Created by yang on 17/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class DropDownMenu: UIView {

    typealias OptionChanged = (MenuOption) -> Void

    var optionChanged: OptionChanged?

    // 显示option选择
    func showOptionSelect(_ options: [MenuOption],
                          selectedOption option: MenuOption? = nil,
                          optionChanged: OptionChanged? = nil) {
        guard let superview = superview else {
            return
        }
        if optionDropDownView.superview == nil {
            superview.addSubview(optionDropDownView)
        } else {
            superview.bringSubview(toFront: optionDropDownView)
            optionDropDownView.isHidden = false
        }
        superview.bringSubview(toFront: self)
        optionDropDownView.options = options
        optionDropDownView.selectedOption = option
        optionDropDownView.showMenu()
    }

    var optionHeight: CGFloat {
        set {
            optionDropDownView.optionHeight = newValue
        }
        get {
            return optionDropDownView.optionHeight
        }
    }

    var options: [MenuOption] {
        set {
            optionDropDownView.options = newValue
        }
        get {
            return optionDropDownView.options
        }
    }

    private let bottomLine = CAShapeLayer()

    private let optionDropDownView = OptionDropDownView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        bottomLine.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        layer.addSublayer(bottomLine)

        optionDropDownView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)

        showMenu()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let superview = superview else {
            return
        }
        let lineHeight = 1 / UIScreen.main.scale
        bottomLine.frame = CGRect(x: 0,
                                  y: bounds.height - lineHeight,
                                  width: bounds.width,
                                  height: lineHeight)
        optionDropDownView.menuHeight = bounds.height
        optionDropDownView.frame = CGRect(x: 0,
                                          y: frame.origin.y,
                                          width: superview.frame.width,
                                          height: superview.frame.height - frame.origin.y)
    }

    func showMenu(_ animated: Bool = true) {
        guard let superview = superview else {
            return
        }
        if optionDropDownView.superview == nil {
            superview.addSubview(optionDropDownView)
        } else {
            superview.bringSubview(toFront: optionDropDownView)
            optionDropDownView.isHidden = false
        }
        superview.bringSubview(toFront: self)
        optionDropDownView.showMenu(animated)
    }

    func hideMenu(_ animated: Bool = true) {
        optionDropDownView.hideMenu()
    }
}

class OptionDropDownView: UIView {
    var menuHeight: CGFloat = 0

    var options: [MenuOption] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var selectedOption: MenuOption? {
        set {
            setSelectedOption(newValue)
        }
        get {
            if let indexPath = tableView.indexPathForSelectedRow {
                return options[indexPath.row]
            }
            return nil
        }
    }

    var optionHeight: CGFloat = 30 {
        didSet {
            tableView.rowHeight = optionHeight
        }
    }

    private var tableviewHeight: CGFloat {
        var height = bounds.height
        if #available(iOS 11.0, *) {
            height -= safeAreaInsets.bottom
        }
        return min(CGFloat(options.count) * optionHeight, height - menuHeight)
    }

    weak var delegate: OptionMenuDelegate?

    private let tableView = UITableView(frame: .zero, style: .plain)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        addSubview(tableView)

        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.rowHeight = optionHeight
        tableView.delegate = self
        tableView.dataSource = self
    }

    func showMenu(_ animated: Bool = true) {
        self.isHidden = false
        if animated {
            alpha = 0
            tableView.transform = CGAffineTransform(translationX: 0, y: -tableviewHeight)
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 1
                self.tableView.transform = CGAffineTransform.identity
            })
        }
    }

    func hideMenu(_ animated: Bool = true) {
        if animated {
            var frame = tableView.frame
            frame.origin.y -= frame.height
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
                self.tableView.frame = frame
            }, completion: { finished in
                if finished {
                    self.isHidden = true
                }
            })
        } else {
            self.isHidden = true
        }
    }

    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var originX: CGFloat = 0
        var width: CGFloat = frame.width
        if #available(iOS 11.0, *) {
            originX += self.safeAreaInsets.left
            width -= (self.safeAreaInsets.left + self.safeAreaInsets.right)
        }
        tableView.frame = CGRect(x: originX, y: menuHeight, width: width, height: tableviewHeight)
    }

    private func setSelectedOption(_ option: MenuOption?, animated: Bool = true) {
        if let selectedOption = option, let index = options.index(where: { selectedOption.title == $0.title }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0),
                                animated: animated, scrollPosition: UITableViewScrollPosition.top)
        } else {
            tableView.indexPathsForSelectedRows?.forEach({ tableView.deselectRow(at: $0, animated: animated) })
        }
    }
}

extension OptionDropDownView: UITableViewDataSource, UITableViewDelegate {
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

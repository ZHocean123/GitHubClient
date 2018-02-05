//
//  DropDownMenu.swift
//  GitHubClient_Example
//
//  Created by yang on 17/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

protocol MenuOption {
    var title: String { get }
}

protocol OptionMenuDelegate: class {
    func didSelect(option: MenuOption)
}

@IBDesignable
class DropDownMenu: UIView {

    typealias OptionChanged = (MenuOption) -> Void

    var optionChanged: OptionChanged?

    // 显示option选择
    func showOptionSelect(_ options: [MenuOption],
                          selectedOption option: MenuOption? = nil,
                          optionChanged: OptionChanged? = nil) {
        self.options = options
        self.selectedOption = option
        self.showMenu()
    }

    private let bottomLine = CAShapeLayer()
    private let optionDropDownView = UIView()
    private let optionContainerView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)

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

    var isShowing: Bool = false

    private func setSelectedOption(_ option: MenuOption?, animated: Bool = true) {
        if let selectedOption = option, let index = options.index(where: { selectedOption.title == $0.title }) {
            tableView.selectRow(at: IndexPath(row: index, section: 0),
                                animated: animated, scrollPosition: UITableViewScrollPosition.top)
        } else {
            tableView.indexPathsForSelectedRows?.forEach({ tableView.deselectRow(at: $0, animated: animated) })
        }
    }

    var optionHeight: CGFloat = 30 {
        didSet {
            tableView.rowHeight = optionHeight
        }
    }

    private var tableviewHeight: CGFloat {
        var height = optionDropDownView.bounds.height
        if #available(iOS 11.0, *) {
            height -= optionDropDownView.safeAreaInsets.bottom
        }
        return min(CGFloat(options.count) * optionHeight, height - bounds.height)
    }

    weak var delegate: OptionMenuDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        bottomLine.backgroundColor = #colorLiteral(red: 0.7058823529, green: 0.7058823529, blue: 0.7058823529, alpha: 1).cgColor
        layer.addSublayer(bottomLine)

        optionDropDownView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        optionDropDownView.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        optionDropDownView.addGestureRecognizer(tap)

        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.rowHeight = optionHeight
        tableView.delegate = self
        tableView.dataSource = self

        optionContainerView.addSubview(tableView)

        optionDropDownView.isHidden = true
        optionContainerView.isHidden = true

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

        optionDropDownView.frame = CGRect(x: 0,
                                          y: frame.origin.y,
                                          width: superview.frame.width,
                                          height: superview.frame.height - frame.origin.y)
        optionContainerView.frame = CGRect(x: frame.minX,
                                           y: frame.maxY,
                                           width: frame.width,
                                           height: tableviewHeight)

        if isShowing {
            tableView.frame = optionContainerView.bounds
        } else {
            var tableViewFrame = optionContainerView.bounds
            tableViewFrame.origin.y -= tableViewFrame.height
            tableView.frame = tableViewFrame
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        optionDropDownView.removeFromSuperview()
        optionContainerView.removeFromSuperview()
        superview?.addSubview(optionDropDownView)
        superview?.addSubview(optionContainerView)
    }

    func showMenu(_ animated: Bool = true) {
        guard let superview = superview else {
            return
        }
        isShowing = true
        if optionDropDownView.superview == nil {
            superview.addSubview(optionDropDownView)
        } else {
            superview.bringSubview(toFront: optionDropDownView)
            optionDropDownView.isHidden = false
        }
        if optionContainerView.superview == nil {
            superview.addSubview(optionContainerView)
        } else {
            superview.bringSubview(toFront: optionContainerView)
            optionContainerView.isHidden = false
        }

        superview.bringSubview(toFront: self)

        if animated {
            var tableViewFrame = tableView.frame
            tableViewFrame.origin.y = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.optionDropDownView.alpha = 1
                self.tableView.frame = tableViewFrame
            })
        }
    }

    func hideMenu(_ animated: Bool = true) {
        isShowing = false
        if animated {
            var tableViewFrame = tableView.frame
            tableViewFrame.origin.y = -tableViewFrame.height
            UIView.animate(withDuration: 0.3, animations: {
                self.optionDropDownView.alpha = 0
                self.tableView.frame = tableViewFrame
            }, completion: { finished in
                if finished {
                    self.optionDropDownView.isHidden = true
                    self.optionContainerView.isHidden = true
                }
            })
        } else {
            optionDropDownView.isHidden = true
            optionContainerView.isHidden = true
        }
    }

    @objc
    func handleTap() {
        hideMenu()
    }
}

extension DropDownMenu: UITableViewDataSource, UITableViewDelegate {
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
        optionChanged?(options[indexPath.row])
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

//
//  Layer+Animation.swift
//  GitHubClient_Example
//
//  Created by yang on 13/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

public extension CALayer {
    public func resumeAnimation() {
        let pausedTime = timeOffset
        self.speed = 1
        self.timeOffset = 0
        self.beginTime = 0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }

    public func pauseAnimation() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0
        self.timeOffset = pausedTime
    }
}

//@IBDesignable
//public class Label: UILabel {
//    @IBInspectable public var borderColor:UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }
//    @IBInspectable public var borderWidth:CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable public var cornerRadius:CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//}

@IBDesignable
public class BorderView: UIView {

//    public override func encode(with aCoder: NSCoder) {
//        super.encode(with: aCoder)
//        aCoder.encode(borderColor, forKey: "borderColor")
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        borderColor = aDecoder.decodeObject(forKey: "borderColor") as? UIColor
//    }

    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

//@IBDesignable
//extension UIView {
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return self.layer.borderWidth
//        }
//        set {
//            self.layer.borderWidth = newValue
//            self.setNeedsDisplay()
//        }
//    }
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return self.layer.cornerRadius
//        }
//        set {
//            self.layer.cornerRadius = newValue
//            self.setNeedsDisplay()
//        }
//    }
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            if let cgColor = self.layer.borderColor {
//                return UIColor(cgColor: cgColor)
//            }
//            return nil
//        }
//        set {
//            self.layer.borderColor = newValue?.cgColor
//            self.setNeedsDisplay()
//        }
//    }
//}


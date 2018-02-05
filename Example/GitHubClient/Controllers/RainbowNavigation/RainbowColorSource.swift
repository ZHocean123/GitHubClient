//
//  LLRainbowColorSource.swift
//  Pods
//
//  Created by Danis on 15/11/25.
//
//

import UIKit

@objc public protocol RainbowColorSource {
    @objc optional func navigationBarInColor() -> UIColor
    @objc optional func navigationBarOutColor() -> UIColor
}

@objc public protocol RainbowNavigationMutable {
    @objc optional func currentNavigationBarColor() -> UIColor
}

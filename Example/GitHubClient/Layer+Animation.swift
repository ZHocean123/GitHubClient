//
//  Layer+Animation.swift
//  GitHubClient_Example
//
//  Created by yang on 13/11/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension CALayer {
    open func resumeAnimation() {
        let pausedTime = timeOffset
        self.speed = 1
        self.timeOffset = 0
        self.beginTime = 0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }

    open func pauseAnimation() {
        let pausedTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0
        self.timeOffset = pausedTime
    }
}

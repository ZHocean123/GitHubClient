//
//  DateString.swift
//  MyGithub
//
//  Created by yang on 23/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

let rfc3339DateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    return dateFormatter
}()
let agoFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()

struct DateString {
    var isoDateStr: String
    var date: Date
    var agoDateStr: String

    init?(_ isoDateStr: String) {
        guard let date = rfc3339DateFormatter.date(from: isoDateStr) else {
            return nil
        }
        self.date = date
        self.isoDateStr = isoDateStr
        let minitesSinceNow = -date.timeIntervalSinceNow / 60
        if minitesSinceNow < 60 {
            self.agoDateStr = "\(Int(minitesSinceNow))分钟前"
        } else if minitesSinceNow < 60 * 24 {
            self.agoDateStr = "\(Int(minitesSinceNow / 60))小时前"
        } else {
            self.agoDateStr = agoFormatter.string(from: date)
        }
    }
}

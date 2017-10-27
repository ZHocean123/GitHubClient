//
//  Pagination.swift
//  MyGithub
//
//  Created by yang on 19/10/2017.
//  Copyright © 2017 ocean. All rights reserved.
//

import Foundation

public struct Pagination {
    public var page: Int = 1
    public var perPage: Int = 30

    public init(page: Int = 1, perPage: Int = 30) {
        self.page = page
        self.perPage = perPage
    }

    public var param: [String: Any] {
        return ["page": page, "per_page": perPage]
    }
}

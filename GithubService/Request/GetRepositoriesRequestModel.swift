//
//  GetRepositoriesRequestModel.swift
//  GithubService
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation

public struct GetRepositoriesRequestModel {
    
    public enum Order: String {
        case desc
        case asc
    }
    
    public enum Sort: String {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
    }
    
    public var query: String = ""
    public let sort: Sort = .stars
    public let order: Order = .desc
    public var page: Int = 1
    public let per_page: Int = 20
    
    public init(query: String = "", page: Int = 1) {
        self.page = page
        self.query = query
    }
}

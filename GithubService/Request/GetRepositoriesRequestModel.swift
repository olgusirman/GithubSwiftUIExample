//
//  GetRepositoriesRequestModel.swift
//  GithubService
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation

public struct GetRepositoriesRequestModel: Hashable, Identifiable {
    
    public let id = UUID().uuidString
    
    public enum Order: String {
        case desc
        case asc
    }
    
    public enum Sort: String, CaseIterable, Hashable, Identifiable {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
        
        public var id: Sort {
            self
        }
        
        public var name: String {
            return "\(self)".capitalized
        }
        
    }
    
    public var query: String = ""
    public var sort: Sort = .stars
    public let order: Order = .desc
    public var page: Int = 1
    public let per_page: Int = 20
    
    public init(query: String = "", page: Int = 1, sort: Sort = .stars) {
        self.page = page
        self.query = query
        self.sort = sort
    }
}

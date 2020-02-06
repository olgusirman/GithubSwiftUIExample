//
//  GithubModel.swift
//  GithubCombineExample
//
//  Created by Olgu on 23.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation

// MARK: - Base
public struct GithubModel: Codable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [GithubItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
public struct GithubItem: Codable {
    
    public static let empty = GithubItem(id: 0, fullName: "", owner: GithubOwner.empty)
    
    public let id: Int
    public let fullName: String
    public let owner: GithubOwner
    public let language: String?
    public let forks, openIssues, watchers: Int?
    public let score: Double
 
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case language
        case forks
        case openIssues = "open_issues"
        case watchers
        case score
    }
    
    public init(id: Int, fullName: String, owner: GithubOwner) {
        self.id = id
        self.fullName = fullName
        self.owner = owner
        self.language = nil
        self.forks = nil
        self.openIssues = nil
        self.watchers = nil
        self.score = 0.0
    }
    
}

// MARK: - Owner
public struct GithubOwner: Codable, Hashable {
    
    public static let empty = GithubOwner(id: 0, login: "", avatarURL: "")
    
    public let login: String
    public let id: Int
    public let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
    
    public init(id: Int, login: String, avatarURL: String) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
    }
    
}

//
//  User.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation

// MARK: - User
public struct User: Codable, Equatable, Hashable {
    
    public static let empty = User(id: 0, name: "")
    public static let sample = User(id: Int.random(in: 1...100), name: "Sample User")
    
    public let id: Int
    public let name: String
    public let login: String
    public var avatarUrl: String?
    public let followers: Int
    public let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case login
        case avatarUrl = "avatar_url"
        case followers
        case following
    }
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.login = ""
        avatarUrl = nil
        followers = 0
        following = 0
    }
}

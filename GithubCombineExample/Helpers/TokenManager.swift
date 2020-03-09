//
//  TokenManager.swift
//  GithubCombineExample
//
//  Created by Olgu on 7.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import KeychainSwift

final class TokenManager {
        
    private let keychain = KeychainSwift()
    private let tokenKey = "personalAccessToken"
    
    func configure() {
        keychain.synchronizable = true
    }
    
    func saveToken(value: String) {
        keychain.set(value, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return keychain.get(tokenKey)
    }
    
    func deleteToken() {
        keychain.delete(tokenKey)
    }
    
}

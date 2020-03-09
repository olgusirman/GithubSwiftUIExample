//
//  UserManager.swift
//  GithubCombineExample
//
//  Created by Olgu on 7.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import Combine

final class UserManager: ObservableObject {
        
    ///Current User Data
    @Published var user: User = User.empty
    
    // MARK: - Private Properties
    
    /// Save and get token to keychain
    private let tokenManager = TokenManager()
    private var service: GithubServiceType!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func configure() {
        tokenManager.configure()
        service = GithubService()
    }
    
    var isUserLoggedIn: Bool {
        return self.user.id != 0
    }
    
    func setToken(token: String) {
        guard !token.isEmpty else {
            debugPrint("Token is empty")
            return
        }
        tokenManager.saveToken(value: token)
        getUserData()
    }
    
    func deleteUser() {
        self.user = User.empty
        tokenManager.deleteToken()
    }
    
    func getUserData() {
        
        guard let token = tokenManager.getToken() else {
            debugPrint("There is no token")
            return
        }
        
        service.getUserData(token: token)
            .replaceError(with: User.empty)
            .receive(on: DispatchQueue.main)
            .print()
            .assign(to: \.user, on: self)
            .store(in: &subscriptions)
    }
    
}

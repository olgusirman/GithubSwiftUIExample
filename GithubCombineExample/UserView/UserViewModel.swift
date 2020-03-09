//
//  UserViewModel.swift
//  GithubCombineExample
//
//  Created by Olgu on 7.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Combine

final class UserViewModel: ObservableObject {
    
    // MARK: Private Properties
    private let service: GithubServiceType
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: GithubServiceType = GithubService()) {
        self.service = service
    }
    
}

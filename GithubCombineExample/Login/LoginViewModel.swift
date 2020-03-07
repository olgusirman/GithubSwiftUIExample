//
//  LoginIntent.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    final class Input {
        @Published var username: String = ""
        @Published var personalAccessToken: String = ""
    }
    
    final class Output {
        @Published var isUsernameValid: Bool = false
        @Published var isTokenValid: Bool = false
    }

    
    var input = Input()
    var output = Output()
    
    private var subscriptions = Set<AnyCancellable>()

    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        input.$username
        .debounce(for: 0.7, scheduler: RunLoop.main)
        .removeDuplicates()
        .map { input in
          return input.count >= 3
        }
        .eraseToAnyPublisher()
    }
    
}

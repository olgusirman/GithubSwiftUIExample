//
//  RepositoriesViewModel.swift
//  GithubCombineExample
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import GithubService
import SwiftUI
import Combine
import UIKit

extension GithubItem :Identifiable {}

final class RepositoriesViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var repositoryName = "" {
        didSet {
            isSearching = true
        }
    }
    @Published var isSearching = false
    @Published private (set) var repositories: [GithubItem] = [] {
        didSet {
            isSearching = false
        }
    }
    
    var pageCount = 1
    
    // MARK: Private Properties
    private let service: GithubServiceType
    private var subscriptions = Set<AnyCancellable>()

    init(service: GithubServiceType = GithubService()) {
        self.service = service
        searchRepositories()
    }
    
    enum GithubError: Error {
        case undefined
        case repoNotFound
        
        var errorDescription: String {
            switch self {
            case .undefined: return "Undefined error occured"
            case .repoNotFound: return "Repo not found"
            }
        }
        
    }
    
    // MARK: - Functions
    func searchRepositories(page: Int = 1) {
        $repositoryName
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty && $0.first != " " }
            .compactMap({ GetRepositoriesRequestModel(query: String($0), page: page) })
            .flatMap({ [unowned self] in self.fetchRepositories(request: $0) })
            .replaceError(with: [])
            .assign(to: \.repositories, on: self)
            .store(in: &subscriptions)
    }
    
    func fetchRepositories(request: GetRepositoriesRequestModel) -> AnyPublisher<[GithubItem], Never> {
        service.getRepositories(request: request)
            .map({ $0.items })
            .catch({ _ in Empty() })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

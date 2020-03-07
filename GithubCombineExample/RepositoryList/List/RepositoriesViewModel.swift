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

extension GithubItem: Identifiable {}

final class RepositoriesViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var repositoryName = ""
    @Published var isSearching = false
    
    @Published var repositories: [GithubItem] = [] {
        didSet {
            isSearching = false
        }
    }

    
    var pageCount = 1
    
    // MARK: Private Properties
    private let service: GithubServiceType = GithubService()
    private var subscriptions = Set<AnyCancellable>()

    var searchQueryEmpty: Bool {
        return repositoryName.isEmpty
    }
    
    init() {
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
            .map({ $0.localizedLowercase })
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({ [weak self] (text) in
                if text.isEmpty {
                    self?.isSearching = false
                } else {
                    self?.isSearching = true
                }
                return text
            })
            .filter { !$0.isEmpty }
            .compactMap({ GetRepositoriesRequestModel(query: $0, page: page) })
            .flatMap({ [unowned self] in self.fetchRepositories(request: $0) })
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.repositories, on: self)
            .store(in: &subscriptions)
    }
    
    func fetchRepositories(request: GetRepositoriesRequestModel) -> AnyPublisher<[GithubItem], Never> {
        service.getRepositories(request: request)
            .map({ $0.items })
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
}

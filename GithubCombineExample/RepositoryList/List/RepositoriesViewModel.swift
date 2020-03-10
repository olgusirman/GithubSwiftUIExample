//
//  RepositoriesViewModel.swift
//  GithubCombineExample
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

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
    
    @Published var sortType: GetRepositoriesRequestModel.Sort = .stars
    
    var isLastItemFetched = false
    
    // MARK: Private Properties
    private var subscriptions = Set<AnyCancellable>()
    private let service: GithubServiceType
    private let offset: Int = 5
    private var pageCount = 1 {
        didSet {
            debugPrint("pageCount is set \(self.pageCount)")
        }
    }
    private let debounceTime: Double = 0.4
    
    init(service: GithubServiceType = GithubService()) {
        self.service = service
        searchRepositories()
        bindFilters()
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
    private func searchRepositories() {
        
        $repositoryName
            .map({ $0.localizedLowercase })
            .debounce(for: .seconds(debounceTime), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map({ [weak self] (text) -> String in
                self?.cleanPage()
                return text
            })
            .map({ [weak self] (text) in
                if text.isEmpty {
                    self?.isSearching = false
                } else {
                    self?.isSearching = true
                }
                return text
            })
            .compactMap({ [weak self] in GetRepositoriesRequestModel(query: $0, page: self?.pageCount ?? 1, sort: self?.sortType ?? .stars) })
            .flatMap({ [unowned self] in self.fetchRepositories(request: $0) })
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.repositories, on: self)
            .store(in: &subscriptions)
    }
    
    private func bindFilters() {
        
        $sortType
            .map({ [weak self] (sortType) -> GetRepositoriesRequestModel.Sort in
                self?.cleanPage()
                self?.isSearching = true
                return sortType
            })
            .compactMap({ [weak self] in GetRepositoriesRequestModel(query: self?.repositoryName ?? "", page: self?.pageCount ?? 1, sort: $0) })
            .flatMap({ [unowned self] in self.fetchRepositories(request: $0) })
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.repositories, on: self)
            .store(in: &subscriptions)
        
    }
    
    private func fetchRepositories(request: GetRepositoriesRequestModel) -> AnyPublisher<[GithubItem], Never> {
        service.getRepositories(request: request)
            .map({ $0.items })
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func fetchMoreRepositories<Item: Identifiable>(_ item: Item) {
        
        let isFetchMoreThresHold = Just(repositories.isThresholdItem(offset: offset, item: item)).eraseToAnyPublisher()
        //let isFetchMore = Just(repositories.isLastItem(item)).eraseToAnyPublisher() // use it for fetchin while the only last item appears
        
        let lastItemFetched = Just(isLastItemFetched).eraseToAnyPublisher()
        
        Publishers.CombineLatest(lastItemFetched, isFetchMoreThresHold)
            .eraseToAnyPublisher()
            .allSatisfy({ !$0 && $1 })
            .filter({ $0 })
            .removeDuplicates()
            .flatMap({ [unowned self] _ -> AnyPublisher<Int,Never> in
                self.pageCount += 1
                debugPrint("pageCount updated as \(self.pageCount)")
                return Just(self.pageCount).eraseToAnyPublisher()
            })
            .compactMap({ [unowned self] in GetRepositoriesRequestModel(query: self.repositoryName, page: $0, sort: self.sortType)})
            .print()
            .flatMap({ [unowned self] in self.fetchRepositories(request: $0) })
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] (newItems) -> AnyPublisher<[GithubItem],Never> in
                // Is there any new Items?
                if newItems.isEmpty {
                    // There is no item in nextPage, you don't need to fetch anymore
                    self?.isLastItemFetched = true
                }
                var currentRepositories = self?.repositories ?? []
                currentRepositories.append(contentsOf: newItems)
                return Just(currentRepositories).eraseToAnyPublisher()
        }
        .assign(to: \.repositories, on: self)
        .store(in: &subscriptions)
    }
    
    private func cleanPage() {
        self.pageCount = 1
        self.isLastItemFetched = false
    }
    
}

extension RandomAccessCollection where Self.Element: Identifiable {
    func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { $0.id.hashValue == item.id.hashValue }) else {
            return false
        }
        
        // This approach is just for last cell
        // the distance between the item index and the end index has to be exactly one
        // (the end index is equal to the current number of items in the collection)
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
}

extension RandomAccessCollection where Self.Element: Identifiable {
    func isThresholdItem<Item: Identifiable>(offset: Int,
                                             item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard count > 0 else {
            return false
        }
        
        guard let itemIndex = firstIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        let calculatedOffset = offset < count ? offset : count - 1
        return calculatedOffset == (distance - 1)
    }
}

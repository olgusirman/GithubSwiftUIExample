//
//  RepositoryCellViewModel.swift
//  GithubCombineExample
//
//  Created by Olgu on 27.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import GithubService
import UIKit
import Combine

final class RepositoryCellViewModel: ObservableObject {
    
    @Published var userImage: UIImage?
    
    private var subscriptions = Set<AnyCancellable>()
    var item: GithubItem
    
    init(item: GithubItem) {
        self.item = item
        fetchUserImage()
    }
    
    func fetchUserImage() {
        guard let url = URL(string: item.owner.avatarURL) else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil) // TODO: set placeholderEmpty user image
            .receive(on: RunLoop.main)
            .assign(to: \.userImage, on: self)
            .store(in: &subscriptions)
    }
    
}

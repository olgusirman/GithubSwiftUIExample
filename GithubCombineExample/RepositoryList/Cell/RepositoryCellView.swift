//
//  RepositoryCellView.swift
//  GithubCombineExample
//
//  Created by Olgu on 27.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI
import GithubService

struct RepositoryCellView: View {
    
    @ObservedObject var viewModel: RepositoryCellViewModel
    
    init(viewModel: RepositoryCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            UserImage(image: Image(uiImage: viewModel.userImage ?? UIImage(systemName: "person")!))
            Text(viewModel.item.fullName)
                    .font(.body)
            Spacer()
        }
    }
}

struct RepositoryCellView_Previews: PreviewProvider {
    
    static let owner = GithubOwner(id: 0, login: "Login", avatarURL: "")
    static let item = GithubItem(id: 0, fullName: "FullName", owner: owner)
    
    static var previews: some View {
        RepositoryCellView(viewModel: RepositoryCellViewModel(item: item))
    }
}

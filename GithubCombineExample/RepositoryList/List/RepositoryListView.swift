//
//  RepositoryListView.swift
//  GithubCombineExample
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct RepositoryListView: View {
    
    @ObservedObject var viewModel: RepositoriesViewModel
    
    init(viewModel: RepositoriesViewModel = RepositoriesViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        return NavigationView {
            VStack {
                ZStack {
                    SearchBar(text: $viewModel.repositoryName)
                    ActivityIndicatorView(isRefreshing: $viewModel.isSearching).offset(x: 150, y: 0)
                }
                List {
                    ForEach(viewModel.repositories, id: \.id) { repository in
                        RepositoryCellView(viewModel: RepositoryCellViewModel(item: repository))
                    }
                }
                Spacer()
            }
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    
    static var previews: some View {
        RepositoryListView()
    }
}

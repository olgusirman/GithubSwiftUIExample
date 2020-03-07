//
//  RepositoryListView.swift
//  GithubCombineExample
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct RepositoryListView: View {
    
    @ObservedObject var viewModel = RepositoriesViewModel()
    @State private var presentUserPage = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    SearchBar(text: $viewModel.repositoryName)
                    ActivityIndicatorView(isRefreshing: $viewModel.isSearching)
                }
                List {
                    ForEach(viewModel.repositories, id: \.id) { repository in
                        NavigationLink(destination: RepositoryDetailView(item: repository)) {
                            RepositoryCellView(item: repository)
                        }
                    }
                }.resignKeyboardOnDragGesture()
                    .navigationBarTitle("Repositories")
                    .navigationBarItems( trailing:
                        Button(action: { self.presentProfile() }) {
                            Image(systemName: "person")
                        }
                )
                
            }.sheet(isPresented: $presentUserPage) {
                UserView()
            }
        }
    }
    
    private func presentProfile() {
        self.presentUserPage.toggle()
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    
    static var previews: some View {
        RepositoryListView()
    }
}

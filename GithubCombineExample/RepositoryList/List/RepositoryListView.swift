//
//  RepositoryListView.swift
//  GithubCombineExample
//
//  Created by Olgu on 25.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct RepositoryListView: View {
    
    @EnvironmentObject var userManager: UserManager
    @ObservedObject var viewModel = RepositoriesViewModel()
    @State private var presentUserPage = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ZStack (alignment: .trailing) {
                        SearchBar(text: $viewModel.repositoryName)
                        ActivityIndicatorView(isRefreshing: $viewModel.isSearching).offset(x: -40, y: 0)
                    }
                    Picker(selection: $viewModel.sortType, label: Text("Sort Type")) {
                        ForEach(GetRepositoriesRequestModel.Sort.allCases) { index in
                            Text("\(index.name)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    List (viewModel.repositories) { repository in
                        
                        ZStack {
                            if self.viewModel.repositories.isLastItem(repository) && !self.viewModel.isLastItemFetched {
                                HStack {
                                    Spacer()
                                    ActivityIndicatorView(isRefreshing: .constant(true))
                                    Spacer()
                                }
                                
                            } else {
                                NavigationLink(destination: RepositoryDetailView(item: repository)) {
                                    RepositoryCellView(item: repository)
                                }
                            }
                        }.onAppear {
                            self.viewModel.fetchMoreRepositories(repository)
                        }
                        
                    }
                    .resignKeyboardOnDragGesture()
                    .navigationBarTitle("Repositories")
                    .navigationBarItems( trailing:
                        Button(action: { self.presentProfile() }) {
                            userManager.isUserLoggedIn ? Image(systemName: "person.fill") : Image(systemName: "person")
                        }
                    )
                    
                }
                .sheet(isPresented: $presentUserPage) {
                    AccessTokenView(dismissFlag: self.$presentUserPage) {
                        self.userManager.getUserData()
                    }
                }
                //                HUDView(imageType: .clockwise)
                //                    .opacity(viewModel.isSearching ? 1.0 : 0)
                //                    .rotationEffect(.init(degrees: viewModel.isSearching ? 180 : 0))
                //                    .animation(Animation.easeOut(duration: 1).repeatForever())
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

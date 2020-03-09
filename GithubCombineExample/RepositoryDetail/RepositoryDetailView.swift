//
//  RepositoryDetailView.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.02.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    var item: GithubItem

    var body: some View {
        Text(item.fullName)
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryDetailView(item: GithubItem.sample)
    }
}

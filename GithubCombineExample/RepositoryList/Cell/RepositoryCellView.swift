//
//  RepositoryCellView.swift
//  GithubCombineExample
//
//  Created by Olgu on 27.01.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct RepositoryCellView: View {
    
    var item: GithubItem

    var body: some View {
        HStack {
            UserImage(imageUrl: item.owner.avatarURL)
            Text(item.fullName)
                .font(.body)
                .lineLimit(0)
            Spacer()
        }
    }
}

struct RepositoryCellView_Previews: PreviewProvider {
    
    static let owner = GithubOwner(id: 0, login: "Login", avatarURL: "")
    static let item = GithubItem(id: 0, fullName: "FullName", owner: owner)
    
    static var previews: some View {
        RepositoryCellView(item: item)
    }
}

//
//  ProfileDetailBackgroundView.swift
//  GithubCombineExample
//
//  Created by Olgu on 10.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct ProfileDetailBackgroundView: View {
    var imageUrl: String

    var body: some View {
        KFImage(URL(string: imageUrl)!)
            .placeholder { Image(systemName: "person.circle") }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .blur(radius: 25)
    }
}

struct ProfileDetailBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailBackgroundView(imageUrl: "https://avatars0.githubusercontent.com/u/53901302?v=4")
    }
}

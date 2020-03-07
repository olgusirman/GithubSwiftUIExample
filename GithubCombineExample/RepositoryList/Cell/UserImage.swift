//
//  UserImage.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.02.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import UIKit
import SwiftUI
import KingfisherSwiftUI

struct UserImage: View {
    
    var imageUrl: String
    
    var body: some View {
        KFImage(URL(string: imageUrl)!)
            .placeholder { Image(systemName: "person.circle") }
            .cancelOnDisappear(true)
            .resizable()
            .frame(width: 50, height: 50, alignment: .center)
            .clipShape(Circle())
            .aspectRatio(contentMode: .fill)
            .shadow(color: .gray, radius: 0.5, x: 1, y: 1)
    }
    
}

struct CircleImage_Preview: PreviewProvider {
    static var previews: some View {
        UserImage(imageUrl: "https://avatars0.githubusercontent.com/u/53901302?v=4")
    }
}

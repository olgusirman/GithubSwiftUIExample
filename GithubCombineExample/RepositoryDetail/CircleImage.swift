/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that clips an image to a circle and adds a stroke and shadow.
*/

import SwiftUI
import KingfisherSwiftUI

struct ProfileDetailImage: View {
    
    var imageUrl: String

    var body: some View {
        KFImage(URL(string: imageUrl)!)
            .placeholder { Image(systemName: "person.circle") }
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)
            .clipShape(Circle())
            .aspectRatio(contentMode: .fill)
        .shadow(radius: 5)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailImage(imageUrl: "https://avatars0.githubusercontent.com/u/53901302?v=4")
    }
}

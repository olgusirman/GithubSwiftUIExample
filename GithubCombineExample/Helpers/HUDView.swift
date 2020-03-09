//
//  HUDView.swift
//  GithubCombineExample
//
//  Created by Olgu on 7.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import Foundation
import SwiftUI

struct HUDView: View {
    
  enum ImageType {
    case clockwise
  }
  
  let imageType: ImageType
    
  var body: some View {
    image(for: imageType)
        .background(Color.clear)
  }
  
  private func image(for type: ImageType) -> Image {
    let image: Image
    
    switch imageType {
    case .clockwise:
        image = Image(systemName: "arrow.clockwise.circle")
    }
    
    return image
  }
}

#if DEBUG
struct HUDView_Previews: PreviewProvider {
  static var previews: some View {
    HUDView(imageType: .clockwise)
      .previewLayout(.sizeThatFits)
  }
}
#endif

//
//  AccessTokenView.swift
//  GithubCombineExample
//
//  Created by Olgu on 7.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct AccessTokenView: View {
    
    @State private var token = ""
    @Binding var dismissFlag: Bool
    var loginPressed: (() -> Void)?
    
    var body: some View {
        VStack {
            TextField("Personal Access Token", text: $token)
            Button(action: {
                self.loginPressed?()
                self.dismissFlag.toggle()
            }) {
                HStack {
                    Image(systemName: "signature")
                    Text("Login")
                }.padding()
            }
        }.padding()
    }
}

struct AccessTokenView_Previews: PreviewProvider {
    static var previews: some View {
        AccessTokenView(dismissFlag: .constant(true))
    }
}

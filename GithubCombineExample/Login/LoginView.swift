//
//  LoginView.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var intent = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            LoginTextField(iconName: "person.circle.fill", title: "Username", text: $intent.input.username)
            TextField("Personal Access Token", text: $intent.input.personalAccessToken)            
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

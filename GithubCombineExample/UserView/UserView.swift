//
//  UserView.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @ObservedObject var viewModel = UserViewModel()
    
    @State private var token = ""
    
    var body: some View {
        VStack {
            TextField("Personal Access Token", text: $token)
            Button(action: {
                
            }) {
                HStack {
                    Image(systemName: "signature")
                    Text("Login")
                }.padding()
            }
        }.padding()
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}

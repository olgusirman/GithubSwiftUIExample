//
//  LoginTextField.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

struct LoginTextField: View {
    var iconName: String
    var title: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
            TextField(title, text: $text)
        }
    }
}

struct LoginTextField_Previews: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        LoginTextField(iconName: "person.circle.fill", title: "textFieldTitle", text: $text)
    }
}

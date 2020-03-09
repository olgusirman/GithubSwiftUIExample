//
//  UI+.swift
//  GithubCombineExample
//
//  Created by Olgu on 6.03.2020.
//  Copyright © 2020 Aspendos IT. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

extension AnyTransition {
    static func repeating<T: ViewModifier>(from: T, to: T, duration: Double = 1) -> AnyTransition {
       .asymmetric(
            insertion: AnyTransition
                .modifier(active: from, identity: to)
                .animation(Animation.easeInOut(duration: duration).repeatForever())
                .combined(with: .opacity),
            removal: .opacity
        )
    }
}

struct Opacity: ViewModifier {
    private let opacity: Double
    init(_ opacity: Double) {
        self.opacity = opacity
    }

    func body(content: Content) -> some View {
        content.opacity(opacity)
    }
}

/*
 struct ContentView: View {
     @State var showBlinkingView: Bool = false

     var body: some View {
         VStack {
             if showBlinkingView {
                 Text("I am blinking")
                     .transition(.repeating(from: Opacity(0.3), to: Opacity(0.7)))
             }
             Spacer()
             Button(action: {
                //When the show condition is true on appear, the transition doesn't start. To fix this I do toggle the condition on appear of the superview (The VStack in my example):
                 if self.showBlinkingView {
                     self.showBlinkingView.toggle()
                     DispatchQueue.main.async {
                         self.showBlinkingView.toggle()
                     }
                 }
             }, label: {
                 Text("Toggle blinking view")
             })
         }.padding(.vertical, 50)
     }
 }
 */

//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if (UIAccessibility.isReduceMotionEnabled) {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}


struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    @State private var text = ""
    @State private var yOffset: CGFloat = 0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .scaleEffect(scale)
                .onTapGesture {
                    withOptionalAnimation {
                        self.scale *= 1.5
                    }
            }
            
            Text("Hello, again!")
                .padding()
                .background(reduceTransparency ? Color.black : Color.black.opacity(0.5))
                .foregroundColor(Color.white)
                .clipShape(Capsule())
            
            TextField("Test", text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .offset(x: 0, y: yOffset)
            
            HStack {
                if differentiateWithoutColor {
                    Image(systemName: "checkmark.circle")
                }
                
                Text("Success")
            }
            .padding()
            .background(differentiateWithoutColor ? Color.black : Color.green)
            .foregroundColor(Color.white)
            .clipShape(Capsule())
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            print("⬅️ Moving to the background!")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { (_) in
            print("➡️ Moving back to the foreground!")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { (_) in
            print("🌻 User took a screenshot!")
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)) { (_) in
            withAnimation {
                self.yOffset = -30
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)) { (_) in
            withAnimation {
                self.yOffset = 0
            }
        }
    }
    
    // Custom funcs
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

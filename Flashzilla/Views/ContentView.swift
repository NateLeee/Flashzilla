//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @State private var text = ""
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
            
            TextField("Test", text: $text)
                .padding()
                .offset(x: 0, y: yOffset)
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

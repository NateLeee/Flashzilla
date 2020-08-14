//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import CoreHaptics


struct ContentView: View {
    
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        print("Rectangle tapped!")
                }
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 300, height: 300)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        print("Circle tapped!")
                }
                // .allowsHitTesting(false)
            }
            .padding()
            
            VStack {
                Text("Hello")
                Spacer().frame(height: 100)
                Text("World")
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                print("VStack tapped!")
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

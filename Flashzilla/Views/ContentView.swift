//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1
    
    @State private var currentAngle: Angle = .degrees(0)
    @State private var finalAngle: Angle = .degrees(0)
    
    // how far the circle has been dragged
    @State private var offset = CGSize.zero
    // whether it is currently being dragged or not
    @State private var isDragging = false
    
    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in
                self.offset = value.translation
        }
        .onEnded { _ in
            withAnimation {
                self.offset = .zero
                self.isDragging = false
            }
        }
        
        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    self.isDragging = true
                }
        }
        
        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return VStack {
            Text("Double Tap Me")
                .onTapGesture(count: 2) {
                    print("Double tapped!")
            }
            .padding()
            
            Text("Long Press Me")
                .onLongPressGesture(minimumDuration: 1.5, pressing: { (pressing) in
                    print("In progress: \(pressing)!\n")
                }, perform: {
                    print("Long pressed!")
                })
                .padding()
            
            Text("Zoom / Pinch me")
                .scaleEffect(finalAmount + currentAmount) // So it can animate
                .gesture(
                    MagnificationGesture()
                        .onChanged { amount in
                            print(amount)
                            self.currentAmount = amount - 1 // 'cause it starts with 1
                    }
                    .onEnded { amount in
                        self.finalAmount += self.currentAmount
                        self.currentAmount = 0 // Reset
                        print("\n")
                    }
            )
                .padding()
            
            // MARK: - Rotate Gesture
            Text("Rotate Me")
                .padding()
                .frame(maxWidth: .infinity)
                .border(Color.red, width: 1)
                .rotationEffect(finalAngle + currentAngle)
                .gesture(
                    RotationGesture()
                        .onChanged { (angle) in
                            self.currentAngle = angle
                            print(angle)
                    }
                    .onEnded { (angle) in
                        // print(angle)
                        self.finalAngle += self.currentAngle
                        self.currentAngle = .zero
                        print("\n")
                    }
            )
            
            
            // MARK: - Gesture Clash Example
            VStack {
                Text("Text inside VStack")
                    .onTapGesture {
                        print("Text tapped")
                }
            }
            .padding()
            .highPriorityGesture(TapGesture().onEnded({ _ in
                print("VStack tapped")
            }))
            
            // MARK: - Simultaneous Gesture Example
            VStack {
                Text("Text inside VStack")
                    .onTapGesture {
                        print("Text tapped")
                }
            }
            .padding()
            .simultaneousGesture(TapGesture().onEnded({ _ in
                print("VStack tapped")
            }))
            
            // MARK: - Gesture Sequencing
            Circle()
                .fill(Color.red)
                .frame(width: 64, height: 64)
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .gesture(combined)
            
        }
        .padding()
        .border(Color.blue, width: 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

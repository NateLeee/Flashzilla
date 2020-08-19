//
//  CardView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import AudioToolbox

/**
 AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
 AudioServicesPlaySystemSound(1520) // Actuate `Pop` feedback (strong boom)
 AudioServicesPlaySystemSound(1521) // Actuate `Nope` feedback (series of three weak booms)
 */

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    let card: Card
    
    var removal: (() -> Void)? = nil
    
    @State private var isShowingAnswer = false
    
    @State private var offset = CGSize.zero
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor ?
                        Color.white
                        :
                        Color.white.opacity(1 - Double(abs(offset.width / 81)))
            )
                .background(
                    differentiateWithoutColor ?
                        nil
                        :
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(offset.width > 0 ? Color.green : Color.red)
            )
                
                .shadow(radius: 12, x: 3, y: 2)
            
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if (isShowingAnswer) {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                            .transition(
                                .asymmetric(insertion: .slide, removal: .scale))
                    }
                }
            }
            .padding(18)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 9)))
        .offset(x: offset.width, y: 0)
        .opacity(2 - Double(abs(offset.width / 180)))
            // .rotation3DEffect(Angle(degrees: 27.0), axis: (x: 1, y: 0, z: 0)) // This is causing me trouble!
            .accessibility(addTraits: .isButton)
            .gesture(
                DragGesture()
                    .onChanged { (value) in
                        self.offset = value.translation
                        // Prepare the haptic feedback engine.
                        self.feedback.prepare()
                }
                .onEnded { (value) in
                    if abs(self.offset.width) >= CGFloat(Constants.offsetToRemove) {
                        if (self.offset.width > 0) {
                            self.feedback.notificationOccurred(.success)
                            // Detect if the iPhone was iPhone 6s || 6s+
                            let modelName = UIDevice.current.modelName
                            if (modelName == "iPhone 6s Plus" || modelName == "iPhone 6s") {
                                // AudioServicesPlaySystemSound(1519) // the success haptic could go – that one is likely to be triggered the most often.
                            }
                        } else {
                            self.feedback.notificationOccurred(.error)
                            // Detect if the iPhone was iPhone 6s || 6s+
                            let modelName = UIDevice.current.modelName
                            if (modelName == "iPhone 6s Plus" || modelName == "iPhone 6s") {
                                AudioServicesPlaySystemSound(1521)
                            }
                        }
                        print("Remove the card!")
                        self.removal?()
                        
                    } else {
                        withAnimation(.spring()) {
                            self.offset = .zero
                        }
                    }
                }
        )
            .gesture(TapGesture().onEnded { (_) in
                withAnimation {
                    self.isShowingAnswer.toggle()
                }
            })
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}

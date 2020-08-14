//
//  CardView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI

struct CardView: View {
    let card: Card
    
    var removal: (() -> Void)? = nil
    
    @State private var isShowingAnswer = false
    
    @State private var offset = CGSize.zero
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .shadow(radius: 12, x: 3, y: 2)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                
                if (isShowingAnswer) {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.secondary)
                        .transition(.asymmetric(insertion: .slide, removal: .scale))
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
            .gesture(
                DragGesture()
                    .onChanged { (value) in
                        self.offset = value.translation
                }
                .onEnded { (value) in
                    if abs(self.offset.width) >= 270 {
                        // TODO: - Remove the card
                        print("Remove the card!")
                        self.removal?()
                        
                    } else {
                        self.offset = .zero
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

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
    
    @State private var isShowingAnswer = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                // .shadow(radius: 9)
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
        .rotation3DEffect(Angle(degrees: 27.0), axis: (x: 1, y: 0, z: 0))
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

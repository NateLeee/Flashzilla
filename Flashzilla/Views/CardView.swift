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
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                
                if (isShowingAnswer) {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                
            }
            .padding(18)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .gesture(TapGesture().onEnded { (_) in
            self.isShowingAnswer.toggle()
        })
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
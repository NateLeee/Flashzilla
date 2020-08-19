//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI


extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = total - position // 10 - 0 = 10
        return self.offset(CGSize(width: 0, height: offset * 6))
    }
}


struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var cards = [Card]()
    
    @State private var isActive = true
    @State private var timeRemaining = Constants.timeRemaining
    @State private var showingEditScreen = false
    
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common, options: nil).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // MARK: - All the cards
            VStack {
                Text("Time: \(timeRemaining)s")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 21)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.72)
                )
                
                ZStack {
                    ForEach(0 ..< cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) {
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: self.cards.count)
                        .allowsHitTesting(index == self.cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(self.timeRemaining > 0)
                
                if (cards.isEmpty) {
                    Button(action: {
                        self.resetCards()
                    }) {
                        Text("Restart")
                            .layoutPriority(1)
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            .frame(width: 657)
            
            // Controls for differentiateWithoutColor == true
            if (differentiateWithoutColor || accessibilityEnabled) {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.72))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.72))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                        
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                    .frame(width: 657)
                }
            }
        } // ZStack
            .onReceive(timer) { (time) in
                guard self.isActive == true else { return }
                
                if (self.timeRemaining > 0) {
                    self.timeRemaining -= 1
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { (_) in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { (_) in
            
            if !self.cards.isEmpty {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards) {
            EditCardsView()
        }
        .onAppear(perform: resetCards)
    }
    
    // Custom funcs
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if (cards.isEmpty) {
            self.isActive = false
        }
    }
    
    func resetCards() {
        // cards = [Card](repeating: .example, count: 9)
        loadData()
        timeRemaining = Constants.timeRemaining
        isActive = true
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

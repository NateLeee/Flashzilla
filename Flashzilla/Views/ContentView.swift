//
//  ContentView.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common, options: nil).autoconnect()
    
    @State var counter = 0
    
    var body: some View {
        VStack {
            Text("\(counter)")
                .onReceive(timer) { (time) in
                    if (self.counter >= 5) {
                        self.timer.upstream.connect().cancel()
                        
                    } else {
                        print("The time is now \(time)")
                        self.counter += 1
                    }
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

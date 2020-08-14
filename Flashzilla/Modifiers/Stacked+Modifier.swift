//
//  Stacked+Modifier.swift
//  Flashzilla
//
//  Created by Nate Lee on 8/14/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import Foundation
import SwiftUI

struct Stacked: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

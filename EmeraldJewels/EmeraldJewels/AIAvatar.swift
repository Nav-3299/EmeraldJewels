//
//  AIAvatar.swift
//  EmeraldJewels
//
//  Created by Navpreet Kaur on 08/10/24.
//

import SwiftUI

struct AIAvatar: View {
    @State private var animate = false
    
    var body: some View {
        Image("AIAvatar") // Use your avatar image here
            .resizable()
            .clipShape(Circle())
            .frame(width: 200, height: 200)
            .scaleEffect(animate ? 1.1 : 1.0)
            .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
            .onAppear {
                animate.toggle()
            }
    }
}


#Preview {
    AIAvatar()
}

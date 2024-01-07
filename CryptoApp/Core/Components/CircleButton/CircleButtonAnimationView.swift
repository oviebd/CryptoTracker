//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 6/1/24.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    @State private var animationAmount = 0.0

    var body: some View {
        
        VStack{
            Circle()
                .stroke(lineWidth: 5.0)
                .scale(animate ? 1.0 : 0.0)
                .opacity(animate ? 0.0 : 1.0)
                .animation(animate ? .easeOut(duration: 10.0) : .none, value: animationAmount)
//                .onAppear {
//                    animate.toggle()
//                    animationAmount = animate ? 0.15 : 0.0
//                }
        }
        
       
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
    }
}

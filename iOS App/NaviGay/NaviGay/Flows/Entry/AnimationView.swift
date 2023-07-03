//
//  AnimationView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.07.23.
//

import SwiftUI

struct AnimationView: View {
    
    // MARK: - Properties
    
    @Binding var animationStarted: Bool
    @Binding var animationFinished: Bool
    
    @State private var logoUpAnimated: Bool = false
    @State private var upAnimate1: Bool = false
    @State private var upAnimate2: Bool = false
    @State private var upAnimate3: Bool = false
    @State private var upAnimate4: Bool = false
    @State private var upAnimate5: Bool = false
    @State private var upAnimate6: Bool = false
    @State private var isAnimatingUp: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 50) {
                    Color.red
                        .offset(y: upAnimate1 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100) )
                        .animation(.spring(), value: upAnimate1)
                    Color.orange
                        .offset(y: upAnimate2 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100))
                        .animation(.spring(), value: upAnimate2)
                    Color.yellow
                        .offset(y: upAnimate3 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100))
                        .animation(.spring(), value: upAnimate3)
                    Color.green
                        .offset(y: upAnimate4 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100))
                        .animation(.spring(), value: upAnimate4)
                    Color.blue
                        .offset(y: upAnimate5 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100))
                        .animation(.spring(), value: upAnimate5)
                    Color.purple
                        .offset(y: upAnimate6 ? 0 : (isAnimatingUp ? -geometry.size.height - 100 : geometry.size.height + 100))
                        .animation(.spring(), value: upAnimate6)
                }
                .ignoresSafeArea()
                
                Image("full-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                      .offset(y: logoUpAnimated ? -geometry.size.height - 200 : 0)
                    .animation(.spring(), value: logoUpAnimated)
            }
            .onChange(of: animationStarted, perform: { bool in
                if bool {
                    animate()
                }
            })
        }
    }
    
    // MARK: - Private Functions
    
    private func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isAnimatingUp = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate1 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate2 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate3 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate4 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate5 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (0...0.3))) {
            upAnimate6 = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate1 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate2 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate3 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate4 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate5 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: (2...2.3))) {
            upAnimate6 = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.35) {
            logoUpAnimated = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            animationFinished = true
        }
    }
}
//
//struct AnimationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimationView(animationStarted: .constant(false), animationFinished: .constant(false))
//    }
//}

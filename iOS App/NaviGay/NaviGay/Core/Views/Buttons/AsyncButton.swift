//
//  AsyncButton.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

enum LoadState {
    case normal, loading, success, failure
}

struct AsyncButton<Content>: View where Content: View {

    // MARK: - Properties
    
    @Binding var state: LoadState
    let backgroundColor: Color
    let action: () -> Void
    let content: () -> Content

    // MARK: - View
    
    var body: some View {
        
        switch state {
        case .normal:
            Button {
                action()
            } label: {
                ColoredCapsule(background: backgroundColor) {
                    content()
                }
            }
            .disabled(state == .loading || state == .success || state == .failure)
        case .loading:
            ProgressView()
        case .success:
            Image(systemName: "checkmark")
                .font(.title2)
                .bold()
                .foregroundColor(.green)
        case .failure:
            Image(systemName: "xmark")
                .font(.title2)
                .bold()
                .foregroundColor(.red)
        }
//
//            Button {
//                action()
//            } label: {
//                ColoredCapsule(background: backgroundColor) {
//                    switch state {
//                    case .normal:
//                        content()
//                    case .loading:
//                        ProgressView()
//                    case .success:
//                        Image(systemName: "checkmark")
//                            .font(.title3)
//                            .bold()
//                            .foregroundColor(.white)
//                    case .failure:
//                        Image(systemName: "xmark")
//                            .font(.title3)
//                            .bold()
//                            .foregroundColor(.white)
//                    }
//                }
//            }
            //.disabled(state == .loading || state == .success || state == .failure)
        }
}

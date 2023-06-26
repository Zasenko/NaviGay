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
            Button {
                action()
            } label: {
                ColoredCapsule(background: AppColors.red) {
                    switch state {
                    case .normal:
                        content()
                    case .loading:
                        ProgressView()
                    case .success:
                        Image(systemName: "checkmark")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                    case .failure:
                        Image(systemName: "xmark")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .clipped()
            }
            .disabled(state == .loading || state == .success || state == .failure)
        }
}

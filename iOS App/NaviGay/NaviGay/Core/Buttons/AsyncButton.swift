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
    let action: () async -> Void
    let content: () -> Content

    // MARK: - View
    
    var body: some View {
            Button {
                Task {
                    await action()
                }
            } label: {
                switch state {
                case .normal:
                    content()
                case .loading:
                    ProgressView()
                case .success:
                    Image(systemName: "checkmark")
                        .bold()
                        .foregroundColor(.green)
                case .failure:
                    Image(systemName: "xmark")
                        .bold()
                        .foregroundColor(AppColors.red)
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .frame(height: 50)
            .background {
                switch state {
                case .normal:
                    backgroundColor
                default:
                    Color.clear
                }
            }
            .clipShape(Capsule(style: .continuous))
            .disabled(state == .loading || state == .success || state == .failure)
        }
}

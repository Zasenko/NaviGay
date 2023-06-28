//
//  PasswordTextField.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var text: String
    @Binding var invalidAttempts: Int
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)
            SecureField("Password", text: $text)
                .lineLimit(1)
                .autocorrectionDisabled(true)

        }
        .padding(10)
        .background(AppColors.lightGray6)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidAttempts == 0 ? .clear : .red)
        }
        .modifier(ShakeEffect(animatableData: CGFloat(invalidAttempts)))
        
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(text: .constant(""), invalidAttempts: .constant(0))
    }
}

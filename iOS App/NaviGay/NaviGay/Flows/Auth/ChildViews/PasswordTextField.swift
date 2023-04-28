//
//  PasswordTextField.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct PasswordTextField: View {
    
    @Binding var text: String
    @Binding var invalidPasswordAttempts: Int
    
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)
            SecureField("Password", text: $text)
               // .focused($focusedField, equals: .password)
                .lineLimit(1)
                .autocorrectionDisabled(true)
                .onSubmit {
               //     focusedField = nil
                }
        }
        .padding()
        .background(AppColors.lightGray)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidPasswordAttempts == 0 ? .clear : .red)
        }
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(text: .constant(""), invalidPasswordAttempts: .constant(0))
    }
}
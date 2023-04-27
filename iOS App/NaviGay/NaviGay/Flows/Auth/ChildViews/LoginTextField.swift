//
//  LoginTextField.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct LoginTextField: View {
    
    @Binding var text: String
    @Binding var invalidLoginAttempts: Int
    
    var body: some View {
        HStack {
            AppImages.envelope
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)
            TextField("Email", text: $text)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .lineLimit(1)
//                .onSubmit {
//                    focusedField = .password
//                }
        }
        .padding()
        .background(AppColors.lightGray)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(invalidLoginAttempts == 0 ? .clear : .red)
        }
    }
}

struct AuthTextField_Previews: PreviewProvider {
    static var previews: some View {
        LoginTextField(text: .constant(""), invalidLoginAttempts: .constant(0))
    }
}

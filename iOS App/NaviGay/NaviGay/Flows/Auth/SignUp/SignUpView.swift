//
//  SignUpView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

struct SignUpView: View {
    
    private enum FocusField: Hashable, CaseIterable {
        case email, password
    }
    
    // MARK: - Properties
    
    @StateObject var viewModel: SignUpViewModel
    @FocusState private var focusedField: FocusField?
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Sign Up")
                    .font(.largeTitle.bold())
                loginTextField
                passwordTextField
                    .padding(.bottom, 20)
                signUpButtonView
                    .padding(.bottom, 20)
                errorView
                Spacer()
            }
            .padding()
            .frame(maxWidth: 400)
            .disabled(viewModel.allViewsDisabled)
            .onSubmit(focusNextField)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            focusedField = nil
        }
    }
    
    // MARK: - Views
    
    var loginTextField: some View {
        HStack {
            AppImages.envelope
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .lineLimit(1)
                .focused($focusedField, equals: .email)
        }
        .padding(10)
        .background(AppColors.lightGray6  )
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 2)
                .foregroundColor(viewModel.invalidLoginAttempts == 0 ? .clear : AppColors.red)
        }
        .modifier(ShakeEffect(animatableData: CGFloat(viewModel.invalidLoginAttempts)))
    }
    
    var passwordTextField: some View {
        HStack {
            Image(systemName: "lock")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondary)
                .frame(width: 20, height: 20)
                SecureField("Password", text: $viewModel.password)
                    .lineLimit(1)
                    .autocorrectionDisabled(true)
                    .focused($focusedField, equals: .password)
        }
        .padding(10)
        .background(AppColors.lightGray6)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(viewModel.invalidPasswordAttempts == 0 ? .clear : .red)
        }
        .modifier(ShakeEffect(animatableData: CGFloat(viewModel.invalidPasswordAttempts)))
    }
    
    private var signUpButtonView: some View {
        HStack(spacing: 20) {
            AsyncButton(state: $viewModel.singUpButtonState, backgroundColor: .green) {
                focusedField = nil
                checkFields()
            } content: {
                Text("Sign Up")
                    .bold()
                    .foregroundColor(.white)
            }
            
            Button {
                focusedField = nil
                viewModel.closeButtonTapped()
            } label: {
                Text("Close")
                    .padding()
            }
            .padding(.horizontal)
            .padding(.horizontal)
        }
    }
    
    private var errorView: some View {
        Text(viewModel.error)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 50, alignment: .center)
            .foregroundColor(AppColors.red)
        
    }
    
    // MARK: - Private Functions
    
    private func focusNextField() {
        switch focusedField {
        case .email:
            if viewModel.password.isEmpty {
                focusedField = .password
            } else {
                focusedField = nil
            }
        case .password:
            if viewModel.email.isEmpty {
                focusedField = .email
            } else {
                focusedField = nil
            }
        case .none:
            break
        }
    }
    
    private func checkFields() {
        if viewModel.email.isEmpty {
            focusedField = .email
        } else if viewModel.password.isEmpty {
            focusedField = .password
        } else {
            viewModel.signUpButtonTapped()
        }
    }
}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}

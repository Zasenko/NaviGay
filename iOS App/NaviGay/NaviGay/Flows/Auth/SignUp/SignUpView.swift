//
//  SignUpView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

struct SignUpView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: SignUpViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("Sign Up")
                    .font(.largeTitle.bold())
                LoginTextField(text: $viewModel.email, invalidAttempts: $viewModel.invalidLoginAttempts)
                PasswordTextField(text: $viewModel.password, invalidAttempts: $viewModel.invalidPasswordAttempts)
                loginButtonView
                errorView
                Spacer()
            }
            .padding()
            .frame(maxWidth: 400)
            .disabled(viewModel.allViewsDisabled)
        }
        .frame(maxWidth: .infinity)
        .background(.yellow)
        .onTapGesture {
            withAnimation {
              //  focusedField = nil
            }
        }
    }
    
    // MARK: - Views
    
    private var loginButtonView: some View {
        HStack(spacing: 10) {
            AsyncButton(state: $viewModel.loginButtonState, backgroundColor: AppColors.red) {
             //   focusedField = nil
                viewModel.signUpButtonTapped()
            } content: {
                Text("Login")
                    .bold()
                    .foregroundColor(.white)
            }
            
            Button {
            //    focusedField = nil
                viewModel.closeButtonTapped()
            } label: {
                Text("Close")
                    .padding()
            }
        }
    }
    
    private var errorView: some View {
        Text(viewModel.error)
            .font(.callout.bold())
            .foregroundColor(AppColors.red)
            .frame(height: 50)
    }
}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}

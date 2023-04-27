//
//  LoginView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct LoginView: View {
    
//    private enum Field: Hashable {
//        case email
//        case password
//    }
    
    // MARK: - Properties
    
    @StateObject var viewModel = LoginViewModel()
    //@FocusState private var focusedField: Field?
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("Login")
                    .font(.largeTitle.bold())
                
                LoginTextField(text: $viewModel.email, invalidLoginAttempts: $viewModel.invalidLoginAttempts)
                
                PasswordTextField(text: $viewModel.password, invalidPasswordAttempts: $viewModel.invalidPasswordAttempts)
                forgetPasswordButton
                loginButtonView
                errorView
                Spacer()
                signUpView
            }
            .padding(.horizontal)
            .frame(maxWidth: 400)
            .disabled(viewModel.allViewsDisabled)
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            withAnimation {
              //  focusedField = nil
            }
        }
        .fullScreenCover(isPresented: $viewModel.isSignUpViewOpen) {
        //    viewModel.signUpViewDismissed()
        } content: {
       //     viewModel.makeSignUpView()
        }
    }
    
    // MARK: - Private properties / Views
    
//    private var loginField: some View {
//        HStack {
//            Image(systemName: "envelope")
//                .resizable()
//                .scaledToFit()
//                .foregroundColor(.secondary)
//                .frame(width: 20, height: 20)
//            TextField("Email", text: $viewModel.email)
//                .keyboardType(.emailAddress)
//                .autocorrectionDisabled(true)
//                .textInputAutocapitalization(.never)
//                .lineLimit(1)
//                .focused($focusedField, equals: .email)
//                .onSubmit {
//                    focusedField = .password
//                }
//        }
//        .padding()
//        .background(AppColors.lightGray)
//        .cornerRadius(8)
//        .overlay {
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(lineWidth: 1)
//                .foregroundColor(viewModel.invalidLoginAttempts == 0 ? .clear : .red)
//        }
//      //  .modifier(ShakeEffect(animatableData: CGFloat(viewModel.invalidLoginAttempts)))
//        .padding(.bottom, 10)
//    }
    
//    private var passwordField: some View {
//        HStack {
//            Image(systemName: "lock")
//                .resizable()
//                .scaledToFit()
//                .foregroundColor(.secondary)
//                .frame(width: 20, height: 20)
//            SecureField("Password", text: $viewModel.password)
//                .focused($focusedField, equals: .password)
//                .lineLimit(1)
//                .autocorrectionDisabled(true)
//                .onSubmit {
//                    focusedField = nil
//                }
//        }
//        .padding()
//        .background(AppColors.lightGray)
//        .cornerRadius(8)
//        .overlay {
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(lineWidth: 1)
//                .foregroundColor(viewModel.invalidPasswordAttempts == 0 ? .clear : .red)
//        }
//      //  .modifier(ShakeEffect(animatableData: CGFloat(viewModel.invalidPasswordAttempts)))
//    }
    
    private var forgetPasswordButton: some View {
        Button {
           // focusedField = nil
         //   viewModel.skipButtonTapped()
        } label: {
            Text("Forget password?")
        }
        .padding(.bottom)
        .padding(.bottom)
    }
    
    private var loginButtonView: some View {
        HStack(spacing: 10) {
            
            AsyncButton(state: $viewModel.loginButtonState, backgroundColor: AppColors.red) {
             //   focusedField = nil
             //   viewModel.loginButtonTapped()
            } content: {
                Text("Login")
                    .bold()
                    .foregroundColor(.white)
            }
            
            Button {
            //    focusedField = nil
            //    viewModel.skipButtonTapped()
            } label: {
                Text("Skip")
                    .padding()
            }
        }
    }
    
    private var signUpView: some View {
        HStack {
            Text("Don't have an account?")
            Button {
             //   focusedField = nil
              //  viewModel.signUpButtonTapped()
            } label: {
                Text("Sign Up")
                    .bold()
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

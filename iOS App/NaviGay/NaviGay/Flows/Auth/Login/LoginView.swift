//
//  LoginView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

enum FocusField: Hashable, CaseIterable {
        case email, password
    }

struct LoginView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusField?

    // MARK: - Body
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.largeTitle.bold())
                
                LoginTextField(text: $viewModel.email,
                               invalidAttempts: $viewModel.invalidLoginAttempts)
                .focused($focusedField, equals: .email)
                
                PasswordTextField(text: $viewModel.password,
                                  invalidAttempts: $viewModel.invalidPasswordAttempts)
                .focused($focusedField, equals: .password)
                
                forgetPasswordButton
                loginButtonView
                errorView
                Spacer()
                signUpView
            }
            .padding()
            .frame(maxWidth: .infinity)
            .disabled(viewModel.allViewsDisabled)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.container)
        .onTapGesture {
            withAnimation {
              //  focusedField = nil
            }
        }
        .fullScreenCover(isPresented: $viewModel.isSignUpViewOpen) {
            SignUpView(viewModel: SignUpViewModel(networkManager: viewModel.networkManager,
                                                  authManager: viewModel.authManager,
                                                  userDataManager: viewModel.userDataManager,
                                                  entryRouter: $viewModel.entryRouter,
                                                  isUserLogin: $viewModel.isUserLogin,
                                                  isSignUpViewOpen: $viewModel.isSignUpViewOpen))
        }
    }
    
    // MARK: - Private properties / Views
    
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
                viewModel.loginButtonTapped()
            } content: {
                Text("Login")
                    .bold()
                    .foregroundColor(.white)
            }
            
            Button {
                viewModel.skipButtonTapped()
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
                viewModel.signUpButtonTapped()
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

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewModel: LoginViewModel(networkManager: AuthNetworkManager(networkMonitor: NetworkMonitor(), api: ApiProperties()), authManager: AuthManager(), userDataManager: UserDataManager(manager: CoreDataManager()), entryRouter: .constant(.loginView)))
//    }
//}

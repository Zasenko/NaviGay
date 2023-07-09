//
//  LoginView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 27.04.23.
//

import SwiftUI

struct LoginView: View {
    
    private enum FocusField: Hashable, CaseIterable {
        case email, password
    }
    
    // MARK: - Properties
    
    @StateObject var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusField?
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            AppColors.background
            VStack {
                Spacer()
                Text("Login")
                    .font(.largeTitle.bold())
                loginTextField
                passwordTextField
                    .padding(.bottom, 20)
                loginButtonView
                    .padding(.bottom, 20)
                forgetPasswordButton
                    .padding(.bottom)
                errorView
                Spacer()
                signUpView
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
        .fullScreenCover(isPresented: $viewModel.isSignUpViewOpen) {
            SignUpView(viewModel: SignUpViewModel(networkManager: viewModel.networkManager,
                                                  authManager: viewModel.authManager,
                                                  userDataManager: viewModel.userDataManager,
                                                  keychinWrapper: viewModel.keychinWrapper,
                                                  entryRouter: $viewModel.entryRouter,
                                                  lastLoginnedUserId: $viewModel.lastLoginnedUserId,
                                                  isSignUpViewOpen: $viewModel.isSignUpViewOpen,
                                                  user: $viewModel.user,
                                                  isUserLoggedIn: $viewModel.isUserLoggedIn))
        }
    }
    
    // MARK: - Private properties / Views
    
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
    
    private var forgetPasswordButton: some View {
        Button {
            focusedField = nil
            viewModel.cleanFields()
        } label: {
            Text("Forget password?")
        }
    }
    
    private var loginButtonView: some View {
        HStack(spacing: 20) {
            Button {
                focusedField = nil
                viewModel.cleanFields()
                viewModel.skipButtonTapped()
            } label: {
                Text("Skip")
                    .padding()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            
            AsyncButton(state: $viewModel.loginButtonState, backgroundColor: .green) {
                focusedField = nil
                checkFields()
            } content: {
                Text("Login")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(minWidth: 100)
        }
    }
    
    private var signUpView: some View {
        HStack {
            Text("Don't have an account?")
            Button {
                focusedField = nil
                viewModel.cleanFields()
                viewModel.signUpButtonTapped()
            } label: {
                ColoredCapsule(background: .blue) {
                    Text("Sign Up")
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }
        .scaleEffect(y: focusedField == nil ? 1 : 0, anchor: .bottom)
        .opacity(focusedField == nil ? 1 : 0)
        .animation(.spring(), value: focusedField)
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
            viewModel.loginButtonTapped()
        }
    }
    
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewModel: LoginViewModel(entryRouter: .constant(.loginView), isUserLogin: .constant(false), userDataManager: UserDataManager(manager: CoreDataManager(), networkManager: UserDataNetworkManager()), networkManager: AuthNetworkManager(), authManager: AuthManager()))
//    }
//}

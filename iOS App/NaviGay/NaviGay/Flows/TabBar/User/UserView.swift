//
//  UserView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 03.05.23.
//

import SwiftUI

struct UserView: View {
    
    // MARK: - Body
    
    @StateObject var viewModel: UserViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Spacer()
            if viewModel.isUserLogin {
                userLoginView
            } else {
                userLogOutView
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Views
    
    var userLogOutView: some View {
        Button {
            viewModel.loginButtonTapped()
        } label: {
            ColoredCapsule(background: AppColors.red) {
                VStack {
                    Text("Login")
                    Text("Registration")
                }
            }
        }
    }
    
    var userLoginView: some View {
        
        VStack {
            
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.userDataManager.user?.photo)) {
                AppImages.iconPerson
                    .resizable()
                    .scaledToFit()
                    .padding(50)
            }
            .frame(width: 200, height: 200)
            .background(AppColors.lightGray5)
            .clipShape(Circle())
//
            Text(viewModel.userDataManager.user?.name ?? "")
                .font(.title)
            Text(viewModel.userDataManager.user?.bio ?? "add information about you")
            Spacer()
            Button {
                viewModel.logOutButtonTapped()
            } label: {
                ColoredCapsule(background: AppColors.red) {
                    Text("Log Out")
                }
            }
            Spacer()
        }
    }
    
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(userDataManager: UserDataManager(manager: CoreDataManager(), networkManager: UserDataNetworkManager()), entryRouter: .constant(.tabView), isUserLogin: .constant(true)))
    }
}

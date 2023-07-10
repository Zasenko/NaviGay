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
            if viewModel.isUserLoggedIn {
                userLoginView
            } else {
                userLogOutView
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Views
    
    var userLogOutView: some View {
        VStack {
            Spacer()
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
            Spacer()
        }
    }
    
    var userLoginView: some View {
        VStack {
            CachedImageView(viewModel: CachedImageViewModel(url: viewModel.user?.photo)) {
                AppImages.iconPerson
                    .resizable()
                    .scaledToFit()
                    .padding(50)
            }
            .frame(width: 200, height: 200)
            .background(AppColors.lightGray5)
            .clipShape(Circle())
            //
            Text(viewModel.user?.name ?? "")
                .font(.title)
            Text(viewModel.user?.bio ?? "add information about you")
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

//struct UserView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserView(viewModel: UserViewModel(userDataManager: UserDataManager(manager: CoreDataManager(), networkManager: UserDataNetworkManager()), entryRouter: .constant(.tabView), isUserLogin: .constant(true)))
//    }
//}

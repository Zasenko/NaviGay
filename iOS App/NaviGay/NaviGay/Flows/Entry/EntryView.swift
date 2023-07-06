//
//  ContentView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import SwiftUI
import CoreData

struct EntryView: View {
    
    // MARK: - Properties
    
    @StateObject var viewModel: EntryViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            if viewModel.animationFinished {
                switch viewModel.router {
                case .loginView:
                    LoginView(viewModel: LoginViewModel(entryRouter: $viewModel.router,
                                                        isUserLoggedIn: $viewModel.isUserLoggedIn,
                                                        lastLoginnedUserId: $viewModel.lastLoginnedUserId, user: $viewModel.user,
                                                        userDataManager: viewModel.userDataManager,
                                                        networkManager: AuthNetworkManager(),
                                                        authManager: AuthManager(),
                                                        keychinWrapper: viewModel.keychinWrapper))
                case .tabView:
                    TabBarView(viewModel: TabBarViewModel(isUserLoggedIn: $viewModel.isUserLoggedIn,
                                                          entryRouter: $viewModel.router,
                                                          user: $viewModel.user,
                                                          dataManager: viewModel.dataManager,
                                                          locationManager: LocationManager(),
                                                          userDataManager: viewModel.userDataManager,
                                                          keychinWrapper: viewModel.keychinWrapper))
                }
            } else {
                AnimationView(animationStarted: $viewModel.animationStarted, animationFinished: $viewModel.animationFinished)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView(vm: EntryViewModel(userDataManager: UserDataManager(manager: CoreDataManager())))
//    }
//}

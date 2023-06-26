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
            switch viewModel.router {
            case .logoView:
                Image("full-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            case .loginView:
                LoginView(viewModel: LoginViewModel(entryRouter: $viewModel.router,
                                                    isUserLogin: $viewModel.isUserLogin,
                                                    userDataManager: viewModel.userDataManager,
                                                    networkManager: AuthNetworkManager(),
                                                    authManager: AuthManager()))
            case .tabView:
                TabBarView(viewModel: TabBarViewModel(isUserLogin: $viewModel.isUserLogin,
                                                      dataManager: viewModel.dataManager, locationManager: LocationManager(), userDataManager: viewModel.userDataManager))
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView(vm: EntryViewModel(userDataManager: UserDataManager(manager: CoreDataManager())))
//    }
//}

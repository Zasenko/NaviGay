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
    
    @StateObject var vm: EntryViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            switch vm.router {
            case .logoView:
                Image("full-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
            case .loginView:
                
                // TODO networkMonitor api
                
                LoginView(viewModel: LoginViewModel(networkManager: AuthNetworkManager(networkMonitor: NetworkMonitor(), api: ApiProperties()), authManager: AuthManager(), userDataManager: vm.userDataManager, entryRouter: $vm.router, isUserLogin: $vm.isUserLogin))
                
            case .tabView:
                TabBarView(viewModel: TabBarViewModel(isUserLogin: $vm.isUserLogin))
            }
        }
        .onAppear() {
            vm.checkUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(vm: EntryViewModel(userDataManager: UserDataManager(manager: CoreDataManager())))
    }
}

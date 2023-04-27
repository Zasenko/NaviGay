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
                LoginView()
            case .tabView:
                TabView()
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

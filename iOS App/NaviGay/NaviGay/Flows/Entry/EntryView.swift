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
    @EnvironmentObject var viewBuilder: ViewBuilderManager
    
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
                viewBuilder.buildLoginView(entryRouter: $viewModel.router, isUserLogin: $viewModel.isUserLogin)
            case .tabView:
                viewBuilder.buildTabBarView(isUserLogin: $viewModel.isUserLogin)
            }
        }
        //TODO - убрать в EntryViewModel
        .onAppear() {
            viewModel.checkUser()
        }

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryView(vm: EntryViewModel(userDataManager: UserDataManager(manager: CoreDataManager())))
//    }
//}

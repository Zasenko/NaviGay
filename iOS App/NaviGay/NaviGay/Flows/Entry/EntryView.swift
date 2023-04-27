//
//  ContentView.swift
//  NaviGay
//
//  Created by Dmitry Zasenko on 25.04.23.
//

import SwiftUI
import CoreData

struct EntryView: View {
    
    @StateObject var vm: EntryViewModel
    
    var body: some View {
        
        VStack {
            switch vm.router {
            case .logoView:
                Image("full-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                
            case .loginView:
                Color.blue
            case .tabView:
                Color.red
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
